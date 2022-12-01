//
//  CollectionViewHeader.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/30.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    let headerLabel = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        headerLabel.sizeToFit()
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
        }
    }
}
