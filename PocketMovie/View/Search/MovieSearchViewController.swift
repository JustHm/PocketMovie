//
//  MovieSearchViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit

class MovieSearchViewController: UICollectionViewController {
    var query = ""
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
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        fetchMovie(text: query)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        
        let data = searchResult[indexPath.row]
        let poster = data.posters.components(separatedBy: "|")[0]
        cell.setup(imageURL: poster, title: data.movieNm)
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = searchResult[indexPath.row]
        
        let vc = MovieDetailViewController()
        vc.setup(data: selected)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.bounds.width
        return CGSize(width: screenWidth/3, height: screenWidth/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenWidth = view.bounds.width / 10
        return UIEdgeInsets(top: 0, left: screenWidth, bottom: 0, right: screenWidth)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        query = text
        searchResult.removeAll()
        fetchMovie(text: text)
    }
    private func fetchMovie(text: String) {
        APIService.shared.searchMovie(title: text, releaseDate: nil, startCount: searchResult.count, completion: { [weak self] response in
            if response.result == nil, (self?.searchResult.isEmpty ?? true) {
                self?.discriptionLabel.isHidden = false
                self?.searchResult = []
                return
            }
            if let temp = response.result, !temp.isEmpty {
                self?.discriptionLabel.isHidden = true
                self?.searchResult.append(contentsOf: temp)
                self?.collectionView.reloadData()
                // 생성되어 있는 cell과 대응되지 않아 오류가 뜨고 걍 reeloadData로 실행된다..
                // 그래도 아래 방법으로 하면 데이터를 더 가져올때 깜빡이는 현상은 사라진다.
                //                let startIndex = (self?.searchResult.count)!
                //                let indexPath: [IndexPath] = (startIndex..<(startIndex + temp.count)).map {
                //                    return [0, $0]
                //                }
                //                self?.collectionView.reloadItems(at: indexPath)
            }
        })
    }
}

extension MovieSearchViewController: UISearchResultsUpdating {
    //searchBar에 text가 업데이트 될 때 마다 호출됨.
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            self.searchResult = []
            self.collectionView.reloadData()
        }
    }
}
