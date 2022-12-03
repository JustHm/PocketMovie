//
//  ImageCell.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/03.
//

import UIKit

class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
//        imageView.sizeToFit()
        imageView.backgroundColor = .black
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
    }
    
    func configureCell(imageURL: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: nil, options: [
            .transition(.fade(1.2)),
            .forceTransition,
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ])
        
    }
}
