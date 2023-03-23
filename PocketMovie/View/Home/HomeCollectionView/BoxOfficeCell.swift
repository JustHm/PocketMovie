//
//  BoxOfficeCell.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/27.
//

import UIKit
import Kingfisher
import SnapKit

class BoxOfficeCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 64, weight: .black)
        label.sizeToFit()
        label.textColor = .white
        return label
    }()
    
    func setup(imageURL: String, rank: String) {
        setupView()
        configureCell(imageURL: imageURL, rank: rank)
    }
    
    func configureCell(imageURL: String, rank: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"),options: [
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        rankLabel.text = rank
    }
}

private extension BoxOfficeCell {
    func setupView() {
        [imageView, rankLabel].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8) // 넓이를 superView의 80%만 차지하게, 순위 번호 들어가야함
            $0.top.right.bottom.equalToSuperview()
        }
        rankLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(15)
        }
    }
}
