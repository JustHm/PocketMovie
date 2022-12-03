//
//  MovieSearchViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit

class MovieSearchViewController: UICollectionViewController {
    var searchResult: [Movie] = []
    let discriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(discriptionLabel)
        discriptionLabel.text = "검색결과 없음"
        discriptionLabel.sizeToFit()
        discriptionLabel.isHidden = true
        discriptionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.searchResult = []
//        self.collectionView.reloadData()
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        
        let data = searchResult[indexPath.row]
        let poster = data.posters.components(separatedBy: "|")[0]
        cell.configureCell(imageURL: poster, title: data.title)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = searchResult[indexPath.row]
        
        let vc = MovieDetailViewController()
        vc.configureUI(data: selected)
        self.navigationController?.present(vc, animated: true)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        APIService.shared.searchMovie(title: text, releaseDate: nil, completion: { [weak self] response in
            if response.isEmpty {
                self?.discriptionLabel.isHidden = false
                self?.searchResult = []
            }
            else {
                self?.discriptionLabel.isHidden = true
                self?.searchResult = response
            }
            self?.collectionView.reloadData()
        })
    }
}

extension MovieSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            self.searchResult = []
            self.collectionView.reloadData()
        }
    }
}
