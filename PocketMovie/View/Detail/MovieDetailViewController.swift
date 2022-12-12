//
//  MovieDetailViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit
import SafariServices

class MovieDetailViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.shadowColor = .gray
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.font = .systemFont(ofSize: 24, weight: .black)
        return label
    }()
    private lazy var subInfo: UILabel = {
        let label = UILabel()
        label.shadowColor = .gray
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private lazy var discriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    private lazy var kmdbLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("KMDB 링크", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(kmdbLinkButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    func setup(data: Movie?) {
        guard let data = data else { return }
        titleLabel.text = data.movieNm
        discriptionLabel.text = String(describing: data.plots.plot[0].plotText)
        subInfo.text = String(describing: "|\(data.prodYear)| |\(data.genre)| |\(data.rating)| |\(data.runtime)분|")
        
        posters = data.posters.components(separatedBy: "|")
        kmdbURL = URL(string: data.kmdbURL)
        
        setupView()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 //isPagingEnabled가 true일때 sectionSpacing이 0이여야 밀림현상이 없다.
        // https://stackoverflow.com/questions/29658328/uicollectionview-horizontal-paging-not-centered
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
// MARK: UI & EVENT SETTINGS
private extension MovieDetailViewController {
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white
        view.backgroundColor = .black
        
        [collectionView, titleLabel, subInfo, discriptionLabel, kmdbLinkButton].forEach {
            view.addSubview($0)
        }
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(250)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
        }
        subInfo.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
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
}
