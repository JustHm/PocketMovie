//
//  MovieDetail.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/01.
//

import Foundation

// MARK: - Welcome
struct MovieDetail: Codable {
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let result: [Result] // 여기부터 영화 상세 정보.

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - Result
struct Result: Codable {
    let posters, stlls: String
}
