//
//  MovieCell.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit

class MovieCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    func setup(imageURL: String, title: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"),options: [.cacheOriginalImage])
        titleLabel.text = title
        setupView()
    }
}
private extension MovieCell {
    func setupView() {
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom)
        }
    }
}
