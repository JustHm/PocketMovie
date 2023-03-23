//
//  BoxOfficeJSON.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import Foundation
// Weekly, Daily BoxOffice Model

// MARK: - BoxOffice
struct BoxOfficeJSON: Codable {
    var boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let yearWeekTime: String?
    var weeklyBoxOfficeList: [MovieInfo]?
    var dailyBoxOfficeList: [MovieInfo]?
}

struct MovieInfo: Codable {
    let rank: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let audiCnt: String
}

