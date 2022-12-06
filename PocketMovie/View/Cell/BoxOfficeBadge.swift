//
//  BoxOfficeBadge.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/06.
//

import UIKit

class BoxOfficeBadge: UICollectionReusableView {
    let label = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        
        addSubview(label)
        label.sizeToFit()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .orange
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1)
        }
    }
    
    func configureBadge(text: String) {
        guard text == "NEW" else {
            label.isHidden = true
            self.layer.backgroundColor = UIColor.clear.cgColor
            return
        }
        
        self.layer.backgroundColor = UIColor.white.cgColor
        label.isHidden = false
        label.text = text
        
    }
}
