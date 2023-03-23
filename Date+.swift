//
//  Date+.swift
//  PocketMovie
//
//  Created by 안정흠 on 2023/03/23.
//

import Foundation

extension Date {
    ///영화 검색시 사용되는 일간 날짜 반환
    var dailyDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: self) else { return "20221125" }
        return dateFormatter.string(from: yesterday)
    }
    ///영화 검색시 사용되는 주간 날짜 반환
    var weeklyDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -7, to: self) else { return "20221125" }
        return dateFormatter.string(from: yesterday)
    }
}
