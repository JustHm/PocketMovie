//
//  APIService.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/26.
//
import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    var dailyDate: String { // 어제 날짜로 설정해야함
        return ""
    }
    var weeklyDate: String { // 저번주 날짜로 설정해야함.
        return ""
    }
    func boxOfficeResponse(range: APIInfo.DateRange, completion: @escaping (BoxOffice) -> Void) {
        let url = APIInfo.boxOfficeHost + range.rawValue
        
        // MARK: Parameter Settings (param: key, targetDt (yyyymmdd) 주간일 경우 weekGb (0))
        var param: Parameters = ["key": "none"]
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
                        print("Decode ERROR: \(error.localizedDescription)")
                    }
                    break
                case let .failure(error):
                    print("ERROR CODE: \(String(describing: error.responseCode))")
                    print("\(error.localizedDescription)")
                    break
                }
            })
    }
}
