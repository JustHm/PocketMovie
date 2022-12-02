//
//  MovieDetailViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit
import SwiftUI

class MovieDetailViewController: UIViewController {
    let posterImage = UIImageView()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .gray
        
        [posterImage, titleLabel].forEach {
            view.addSubview($0)
        }
        posterImage.contentMode = .scaleAspectFit
        posterImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
//        titleLabel.text = "DFSSSDF"
        titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(posterImage)
            $0.top.equalTo(posterImage.snp.bottom).offset(12)
        }
    }
    func configure(imageURL: String, title: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        posterImage.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"))
        titleLabel.text = title
    }
    
}

// SwiftUI Preview Provider
struct DetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = MovieDetailViewController()
            return UINavigationController(rootViewController: vc)
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
