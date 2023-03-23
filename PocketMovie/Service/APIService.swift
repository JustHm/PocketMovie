//
//  APIService.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/26.
//
import Foundation
import RxSwift
import Alamofire

private enum ApiKey: String {
    case kobis, kmdb
}
enum NetworkError: Error {
    case invalidJSON
    case networkError
    case unknownError
}

class APIService {
    // MARK: Property
    static let shared = APIService()
    
    // MARK: Util
    private func getAPIKey(hostName: ApiKey) -> String {
        guard let path = Bundle.main.path(forResource: "apiInfo", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let result = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String:String] else {
            return ""
        }
        switch hostName {
        case .kobis:
            return result["kobisKey"] ?? ""
        case .kmdb:
            return result["kmdbKey"] ?? ""
        }
    }
}
// MARK: User Swift Concurrency (Async/await)
extension APIService {
    ///BoxOffice 일간, 주간 정보 모두 반환
    func searchBoxOfficeInfo(dateRange: DateRange) async throws -> [MovieInfo] {
        let url = APIInfo.boxOfficeHost + dateRange.rawValue
        var dataTask: DataTask<BoxOfficeJSON>
        switch dateRange {
        case .daily:
            let param = BoxOfficeRequestModel(key: getAPIKey(hostName: .kobis), targetDt: Date().dailyDate)
            dataTask = AF.request(url, method: .get, parameters: param).serializingDecodable(BoxOfficeJSON.self)
        case .weekly:
            let param = BoxOfficeRequestModel(key: getAPIKey(hostName: .kobis), targetDt: Date().weeklyDate)
            dataTask = AF.request(url, method: .get, parameters: param).serializingDecodable(BoxOfficeJSON.self)
        }
        
        switch await dataTask.result {
        case .success(let data):
            return dateRange == .daily ? data.boxOfficeResult.dailyBoxOfficeList! : data.boxOfficeResult.weeklyBoxOfficeList!
        case .failure(let error):
            print(error.localizedDescription)
            throw error
        }
    }
    func searchMovieInfo(title: String, releaseDate: String?) async throws -> Movie? {
        let url = APIInfo.movieDetailHost
        var date: String {
            if let temp = releaseDate {
                return temp.replacingOccurrences(of: "-", with: "")
            }
            else {
                return ""
            }
        }
        // Parameter Settings
        let param: Parameters = ["ServiceKey": getAPIKey(hostName: .kmdb),
            "collection": "kmdb_new2",
            "detail": "Y",
            "title": title,
            "releaseDts": date
//            "startCount": startCount
        ]
        let dataTask = AF.request(url, method: .get, parameters: param).serializingDecodable(MovieDetailJSON.self)
        switch await dataTask.result {
        case .success(let data):
            guard let data = data.data[0].result else {
                print("가져오기 실패 \(title) : \(data.data)")
                return nil
            }
            return data[0]
        case .failure(let error):
            throw error
        }
    }
}
// MARK: Use Alamofire + escaping closure
extension APIService {
    func boxOfficeResponse(range: DateRange, completion: @escaping (BoxOfficeJSON) -> Void) {
        let url = APIInfo.boxOfficeHost + range.rawValue
        // Parameter Settings (param: key, targetDt (yyyymmdd) 주간일 경우 weekGb (0))
        var parameter: BoxOfficeRequestModel
        switch range {
        case .daily:
            parameter = BoxOfficeRequestModel(key: getAPIKey(hostName: .kobis), targetDt: Date().dailyDate)
        case .weekly:
            parameter = BoxOfficeRequestModel(key: getAPIKey(hostName: .kobis), targetDt: Date().weeklyDate)
        }
        // Request Part
        AF.request(url, method: .get, parameters: parameter)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decode = JSONDecoder()
                        let result = try decode.decode(BoxOfficeJSON.self, from: data)
                        completion(result)
                    } catch {
                        print("BOXOFFICE Decode ERROR: \(error.localizedDescription)")
                    }
                    break
                case let .failure(error):
                    print("BOXOFFICE ERROR CODE: \(String(describing: error.responseCode))")
                    print("\(error.localizedDescription)")
                    break
                }
            })
    }
    
    func searchMovie(title: String, releaseDate: String?, startCount: Int, completion: @escaping (Movies) -> Void) {
        let url = APIInfo.movieDetailHost
        var date: String {
            if let temp = releaseDate {
                return temp.replacingOccurrences(of: "-", with: "")
            }
            else {
                return ""
            }
        }
        // Parameter Settings
        let param: Parameters = [
            "ServiceKey": getAPIKey(hostName: .kmdb),
            "collection": "kmdb_new2",
            "detail": "Y",
            "title": title,
            "releaseDts": date,
            "startCount": startCount
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decode = JSONDecoder()
                        let temp = try decode.decode(MovieDetailJSON.self, from: data)
                        if temp.data[0].result != nil {
                            completion(temp.data[0])
                        } else {
                            completion(Movies(result: nil, totalCount: 0, count: 0))
                        }
                    } catch {
                        print("GETIMAGE Decode ERROR: \(error.localizedDescription)")
                    }
                    break
                case let .failure(error):
                    print("GETIMAGE ERROR CODE: \(String(describing: error.responseCode))")
                    print("\(error.localizedDescription)")
                    break
                }
            })
    }
    
}
// MARK: Rx Example
extension APIService {
    func boxOfficeResponseWithRx(range: DateRange) -> Single<Result<BoxOfficeJSON, NetworkError>> {
        let url = APIInfo.boxOfficeHost + range.rawValue
        
        // MARK: Parameter Settings (param: key, targetDt (yyyymmdd) 주간일 경우 weekGb (0))
        var param: Parameters = ["key": getAPIKey(hostName: .kobis)]
        switch range {
        case .daily:
            param["targetDt"] = Date().dailyDate
        case .weekly:
            param["targetDt"] = Date().weeklyDate
            param["weekGb"] = 0
        }
        return Observable.create { observer in
            let request = AF.request(url, method: .get, parameters: param).responseData{ response in
                switch response.result {
                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(BoxOfficeJSON.self, from: data)
                        // 여기다 이미지 가져오는걸 만들까?
                        observer.onNext(.success(model))
                    } catch {
                        observer.onNext(.failure(NetworkError.invalidJSON))
                    }
                case .failure(_):
                    observer.onNext(.failure(NetworkError.networkError))
                    break
                }
            }
            return Disposables.create { request.cancel() }
        }.asSingle()
    }
}
