//
//  BoxOfficeBadge.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/06.
//

import UIKit

class BoxOfficeBadge: UICollectionReusableView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .orange
        return label
    }()
    func setup(text: String) {
        configureBadge(text: text)
        setupView()
    }
}

private extension BoxOfficeBadge {
    func setupView() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1)
        }
    }
    func configureBadge(text: String) {
        guard text == "NEW" else {
            label.isHidden = true
            return
        }
        label.isHidden = false
        label.text = text
        
    }

}
