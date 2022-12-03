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
    let subInfo = UILabel()
    let discriptionLabel = UILabel()
    var stillCollection: UICollectionViewController!
    
    var posters: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        stillCollection = UICollectionViewController(collectionViewLayout: layout)
        stillCollection.collectionView.dataSource = self
        stillCollection.collectionView.delegate = self
        stillCollection.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: nil, action: nil)

        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        [stillCollection.collectionView, titleLabel, subInfo, discriptionLabel].forEach {
            view.addSubview($0)
        }
        
        stillCollection.collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(250)
        }
//        titleLabel.text = "DFSSSDF"
        titleLabel.numberOfLines = 0
        titleLabel.shadowColor = .gray
        titleLabel.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.font = .systemFont(ofSize: 18, weight: .black)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(stillCollection.collectionView.snp.bottom).offset(12)
        }
        
        
        subInfo.font = .systemFont(ofSize: 12, weight: .bold)
        subInfo.shadowColor = .gray
        subInfo.shadowOffset = CGSize(width: 1, height: 1)
        subInfo.numberOfLines = 0
        subInfo.sizeToFit()
        subInfo.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        discriptionLabel.numberOfLines = 0
        discriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
        discriptionLabel.sizeToFit()
        discriptionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(subInfo.snp.bottom).offset(12)
        }
    }
    func configure(imageURL: String, title: String) {
        let url = URL(string: imageURL.replacingOccurrences(of: "http", with: "https"))
        stilImage.kf.setImage(with: url, placeholder: UIImage(systemName: "trash"))
        titleLabel.text = title
    }
    func configureUI(data: Movie?) {
        guard let data = data else { return }
        titleLabel.text = data.movieNm
        discriptionLabel.text = String(describing: data.plots.plot[0].plotText)
        posters = data.posters.components(separatedBy: "|")
        subInfo.text = String(describing: "|\(data.genre)| |\(data.rating)| |\(data.runtime)분|")
        print(data.vods.vod[0])
    }
}

extension MovieDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        
        cell.configureCell(imageURL: posters[indexPath.row])
        
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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
