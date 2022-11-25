//
//  BoxOffice.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import Foundation
// 영화 진흥원 response는 다 string...

// MARK: - BoxOffice
struct BoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let boxofficeType, showRange: String
    let yearWeekTime: String // Weekly에는 있지만 Daily에는 없음
    let weeklyBoxOfficeList: [MoviewInfo]
}

struct MoviewInfo: Decodable {
    let rank: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let audiCnt: String
    
    //let rnum, rankInten, salesAmt, salesShare, salesInten, salesChange, salesAcc, audiInten, audiChange, audiAcc, scrnCnt, showCnt: String
}

