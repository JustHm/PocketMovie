//
//  MovieDetailViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit
import SafariServices

class MovieDetailViewController: UIViewController {
    let titleLabel = UILabel()
    let subInfo = UILabel()
    let discriptionLabel = UILabel()
    @objc let kmdbLinkButton = UIButton()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    var posters: [String] = []
    var kmdbURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        [collectionView, titleLabel, subInfo, discriptionLabel, kmdbLinkButton].forEach {
            view.addSubview($0)
        }
        [titleLabel, subInfo, discriptionLabel].forEach {
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(250)
        }
        
        titleLabel.shadowColor = .gray
        titleLabel.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.font = .systemFont(ofSize: 24, weight: .black)
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
        }
        
        subInfo.shadowColor = .gray
        subInfo.shadowOffset = CGSize(width: 1, height: 1)
        subInfo.font = .systemFont(ofSize: 12, weight: .bold)
        subInfo.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        discriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
        discriptionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(subInfo.snp.bottom).offset(12)
        }
        kmdbLinkButton.snp.makeConstraints {
            $0.top.equalTo(discriptionLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(12)
        }
    }
    @objc private func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func kmdbLinkButtonTapped() {
        guard let url = kmdbURL else { return }
        let safariView = SFSafariViewController(url: url)
        self.present(safariView, animated: true, completion: nil)
    }
    
    func configureUI(data: Movie?) {
        guard let data = data else { return }
        titleLabel.text = data.movieNm
        discriptionLabel.text = String(describing: data.plots.plot[0].plotText)
        posters = data.posters.components(separatedBy: "|")
        subInfo.text = String(describing: "|\(data.prodYear)| |\(data.genre)| |\(data.rating)| |\(data.runtime)분|")
        
        kmdbURL = URL(string: data.kmdbURL)
        kmdbLinkButton.setTitle("KMDB 링크", for: .normal)
        kmdbLinkButton.setTitleColor(.tintColor, for: .normal)
        kmdbLinkButton.titleLabel?.font = .systemFont(ofSize: 14)
        kmdbLinkButton.addTarget(self, action: #selector(kmdbLinkButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white
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
