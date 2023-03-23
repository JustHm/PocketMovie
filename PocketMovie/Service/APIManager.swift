//
//  APIManager.swift
//  PocketMovie
//
//  Created by 안정흠 on 2023/03/23.
//

import Foundation
import Alamofire

struct APIManager {
    private enum ApiKey: String {
        case kobis, kmdb
    }
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
    ///영화 상세 정보 - 박스 오피스 정보 가져올 때 사용
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
                print("가져오기 실패 [\(title)] : \(data.data)")
                return nil
            }
            return data[0]
        case .failure(let error):
            throw error
        }
    }
    ///영화 검색 - 검색 기능에 사용
    func searchMovieList(title: String, releaseDate: String?) async throws -> Movies {
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
            return data.data[0]
        case .failure(let error):
            throw error
        }
    }
    
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
