//
//  MovieCell.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.font = .systemFont(ofSize: 8, weight: .light)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints {
            $0.left.bottom.equalTo(imageView)
        }
    }
    
    func configure(imageURL: String, title: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"))
        titleLabel.text = title
    }
}