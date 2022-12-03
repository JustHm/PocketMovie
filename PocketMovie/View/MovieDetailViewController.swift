//
//  MovieDetailViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit
import SwiftUI

class MovieDetailViewController: UIViewController {
    let stilImage = UIImageView()
    let titleLabel = UILabel()
    let discriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: nil, action: nil)

        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        [stilImage, titleLabel, discriptionLabel].forEach {
            view.addSubview($0)
        }
        stilImage.contentMode = .scaleAspectFit
        stilImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
//        titleLabel.text = "DFSSSDF"
        titleLabel.sizeToFit()
        titleLabel.font = .systemFont(ofSize: 18, weight: .black)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalTo(stilImage.snp.bottom).offset(12)
        }
        
        
        discriptionLabel.sizeToFit()
        discriptionLabel.font = .systemFont(ofSize: 18, weight: .black)
        discriptionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    func configure(imageURL: String, title: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        stilImage.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"))
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
