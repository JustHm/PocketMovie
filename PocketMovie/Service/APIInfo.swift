//
//  APIInfo.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/26.
//

import Foundation

struct APIInfo {
    static let boxOfficeHost = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/"
    static let movieDetailHost = "https://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp"
    
}
enum DateRange: String {
    case weekly = "searchWeeklyBoxOfficeList.json" // 주간 박스오피스 (주말은 파라미터로 설정)
    case daily = "searchDailyBoxOfficeList.json" // 일간 박스오피스
}
