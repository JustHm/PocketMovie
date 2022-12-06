//
//  APIService.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/26.
//
import Foundation
import Alamofire

private enum ApiKey: String {
    case kobis, kmdb
}

class APIService {
    // MARK: Property
    static let shared = APIService()
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        return dateFormatter
    }
    private var dailyDate: String { // 어제 날짜로 설정해야함
        let date = Date()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) else { return "20221125" }
        return dateFormatter.string(from: yesterday)
    }
    private var weeklyDate: String { // 저번주 날짜로 설정해야함.
        let date = Date()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -7, to: date) else { return "20221125" }
        return dateFormatter.string(from: yesterday)
    }
    
    // MARK: Method
    func boxOfficeResponse(range: APIInfo.DateRange, completion: @escaping (BoxOffice) -> Void) {
        let url = APIInfo.boxOfficeHost + range.rawValue
        
        // MARK: Parameter Settings (param: key, targetDt (yyyymmdd) 주간일 경우 weekGb (0))
        var param: Parameters = ["key": getAPIKey(hostName: .kobis)]
        switch range {
        case .daily:
            param["targetDt"] = dailyDate
        case .weekly:
            param["targetDt"] = weeklyDate
            param["weekGb"] = 0
        }
        
        // MARK: Request Part
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decode = JSONDecoder()
                        let result = try decode.decode(BoxOffice.self, from: data)
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
        // MARK: Parameter Settings
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
                        let temp = try decode.decode(MovieDetail.self, from: data)
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

extension APIService {
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
