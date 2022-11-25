//
//  NaverMovieSearch.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import Foundation

struct NaverMovieSearch: Decodable {
    let total, start, display: Int
    let items: [NaverMovie]
}

struct NaverMovie: Decodable {
    let title, link, image, subtitle, pubDate: String
    let director: String
    let actor: String
    let userRating: String
}

//{
//    "lastBuildDate": "Fri, 25 Nov 2022 21:38:54 +0900",
//    "total": 1,
//    "start": 1,
//    "display": 1,
//    "items": [
//        {
//            "title": "<b>동감</b>",
//            "link": "https://movie.naver.com/movie/bi/mi/basic.nhn?code=215970",
//            "image": "https://ssl.pstatic.net/imgmovie/mdi/mit110/2159/215970_P68_101616.jpg",
//            "subtitle": "Ditto",
//            "pubDate": "2022",
//            "director": "서은영|",
//            "actor": "여진구|조이현|김혜윤|나인우|배인혁|",
//            "userRating": "6.20"
//        }
//    ]
//}
