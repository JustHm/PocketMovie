//
//  ImageCell.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/03.
//

import UIKit

class ImageCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    func setup(imageURL: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: nil, options: [.cacheOriginalImage])
        setupView()
    }
    
}

private extension ImageCell {
    func setupView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
    }
}
