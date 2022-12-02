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
enum KmdbType: String {
    case search, getImage
}

class APIService {
    // MARK: Property
    static let shared = APIService()
    private var dailyDate: String { // 어제 날짜로 설정해야함
        return ""
    }
    private var weeklyDate: String { // 저번주 날짜로 설정해야함.
        return ""
    }
    
    // MARK: Method
    func boxOfficeResponse(range: APIInfo.DateRange, completion: @escaping (BoxOffice) -> Void) {
        let url = APIInfo.boxOfficeHost + range.rawValue
        
        // MARK: Parameter Settings (param: key, targetDt (yyyymmdd) 주간일 경우 weekGb (0))
        var param: Parameters = ["key": getAPIKey(hostName: .kobis)]
        switch range {
        case .daily:
            param["targetDt"] = "20221125"
        case .weekly:
            param["targetDt"] = "20221125"
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
    func getPosterImage(title: String, releaseDate: String, completion: @escaping (String) -> Void) {
        let url = APIInfo.movieDetailHost
        // MARK: Parameter Settings
        let param: Parameters = [
            "ServiceKey": getAPIKey(hostName: .kmdb),
            "collection": "kmdb_new2",
            "detail": "Y",
            "title": title,
            "releaseDts": releaseDate.replacingOccurrences(of: "-", with: "")
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        
                        let decode = JSONDecoder()
                        let temp = try decode.decode(MovieDetail.self, from: data)
                        let result = temp.data[0].result[0].posters
                        completion(result)
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
    //    func kmdbResponse(type: KmdbType, completion: @escaping () -> Void) {
    //        let url = APIInfo.movieDetailHost
    //
    //        // MARK: Parameter Settings
    //        var param: Parameters = [
    //            "ServiceKey": getAPIKey(hostName: .kmdb),
    //            "collection": "kmdb_new2"
    //            "detail": "Y"
    //        ]
    //        switch type {
    //        case .search:
    //            param["targetDt"] = "20201125"
    //        case .getImage:
    //
    //        }
    //    }
    
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
