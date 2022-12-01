//
//  Bundle.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/30.
//
import UIKit

extension Bundle {
    var kobisAPIKey: String {
        guard let file = Bundle.main.path(forResource: "apiInfo", ofType: "plist") else { return ""}
        
        guard let resource = Dictionary(file) else { return "" }
    }
}
