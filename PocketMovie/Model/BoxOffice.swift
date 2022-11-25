//
//  BoxOffice.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import Foundation
// Weekly, Daily BoxOffice Model

// MARK: - BoxOffice
struct BoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange: String
    let yearWeekTime: String?
    let weeklyBoxOfficeList: [MoviewInfo]?
    let dailyBoxOfficeList: [MoviewInfo]?
}

struct MoviewInfo: Decodable {
    let rank: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let audiCnt: String

}

