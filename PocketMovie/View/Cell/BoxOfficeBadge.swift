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
        addSubview(label)
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12)
        label.textColor = label.text == "OLD" ? .gray : .yellow
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
