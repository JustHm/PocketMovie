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
    let imageView = UIImageView()
    let rankLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
//        true로 설정하면 subview가 view의 경계를 넘어갈 시 잘리며
//        false로 설정하면 경계를 넘어가도 잘리지 않게 되는 것!
        
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8) // 넓이를 superView의 80%만 차지하게, 순위 번호 들어가야함
        }
        
        rankLabel.font = .systemFont(ofSize: 82, weight: .black)
        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
        }
    }
    
    func configureCell(imageURL: String, rank: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"))
        rankLabel.text = rank
    }
}
