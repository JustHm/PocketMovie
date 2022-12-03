//
//  MovieDetail.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/01.
//

import Foundation

// MARK: - Root
struct MovieDetail: Codable {
    let data: [Movies] // 배열로 되어있는 의미를 모르겠음 걍 하나임

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - Movies
struct Movies: Codable {
    let result: [Movie]? // 여기부터 영화 상세 정보.

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let docid, movieID, movieSeq, title: String
    var movieNm: String { //KMDB title에 !HS !HE 가 있는 경우 앞뒤로 공백까지 없애줘야 하고, 맨 앞 문자열에 공백이 삽입되어 온다.
        var temp = title.replacingOccurrences(of: " !HS ", with: "")
        temp = temp.replacingOccurrences(of: " !HE ", with: "")
        temp.removeFirst()
        return temp
    }
    let titleEng, titleOrg, titleEtc, prodYear: String
    let directors: Directors
    let actors: Actors
    let nation, company: String
    let plots: Plots
    let runtime, rating, genre: String
    let kmdbURL: String
    let type, use, episodes, ratedYn: String
    let repRatDate, repRlsDate: String
    let ratings: Ratings
    let keywords: String
    let posters, stlls: String
    let staffs: Staffs
    let vods: Vods
    let openThtr: String
    let stat: [Stat]
    let screenArea, screenCnt, salesAcc, audiAcc: String
    let statSouce, statDate, themeSong, soundtrack: String
    let fLocation, awards1, awards2, regDate: String
    let modDate: String
    let codes: Codes
    let commCodes: CommCodes
    let alias: String

    enum CodingKeys: String, CodingKey {
        case docid = "DOCID"
        case movieID = "movieId"
        case movieSeq, title, titleEng, titleOrg, titleEtc, prodYear, directors, actors, nation, company, plots, runtime, rating, genre
        case kmdbURL = "kmdbUrl"
        case type, use, episodes, ratedYn, repRatDate, repRlsDate, ratings, keywords, posters, stlls, staffs, vods, openThtr, stat, screenArea, screenCnt, salesAcc, audiAcc, statSouce, statDate, themeSong, soundtrack, fLocation
        case awards1 = "Awards1"
        case awards2 = "Awards2"
        case regDate, modDate
        case codes = "Codes"
        case commCodes = "CommCodes"
        case alias = "ALIAS"
    }
}

// MARK: - Actors
struct Actors: Codable {
    let actor: [Actor]
}

// MARK: - Actor
struct Actor: Codable {
    let actorNm, actorEnNm, actorID: String

    enum CodingKeys: String, CodingKey {
        case actorNm, actorEnNm
        case actorID = "actorId"
    }
}

// MARK: - Codes
struct Codes: Codable {
    let code: [Code]

    enum CodingKeys: String, CodingKey {
        case code = "Code"
    }
}

// MARK: - Code
struct Code: Codable {
    let codeNm, codeNo: String

    enum CodingKeys: String, CodingKey {
        case codeNm = "CodeNm"
        case codeNo = "CodeNo"
    }
}

// MARK: - CommCodes
struct CommCodes: Codable {
    let commCode: [Code]

    enum CodingKeys: String, CodingKey {
        case commCode = "CommCode"
    }
}

// MARK: - Directors
struct Directors: Codable {
    let director: [Director]
}

// MARK: - Director
struct Director: Codable {
    let directorNm, directorEnNm, directorID: String

    enum CodingKeys: String, CodingKey {
        case directorNm, directorEnNm
        case directorID = "directorId"
    }
}

// MARK: - Plots
struct Plots: Codable {
    let plot: [Plot]
}

// MARK: - Plot
struct Plot: Codable {
    let plotLang, plotText: String
}

// MARK: - Ratings
struct Ratings: Codable {
    let rating: [Rating]
}

// MARK: - Rating
struct Rating: Codable {
    let ratingMain, ratingDate, ratingNo, ratingGrade: String
    let releaseDate, runtime: String
}

// MARK: - Staffs
struct Staffs: Codable {
    let staff: [Staff]
}

// MARK: - Staff
struct Staff: Codable {
    let staffNm, staffEnNm, staffRoleGroup, staffRole: String
    let staffEtc, staffID: String

    enum CodingKeys: String, CodingKey {
        case staffNm, staffEnNm, staffRoleGroup, staffRole, staffEtc
        case staffID = "staffId"
    }
}

// MARK: - Stat
struct Stat: Codable {
    let screenArea, screenCnt, salesAcc, audiAcc: String
    let statSouce, statDate: String
}

// MARK: - Vods
struct Vods: Codable {
    let vod: [VOD]
}

// MARK: - VOD
struct VOD: Codable {
    let vodClass: String
    let vodURL: String

    enum CodingKeys: String, CodingKey {
        case vodClass
        case vodURL = "vodUrl"
    }
}
