//
//  HomeViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

struct ElementKind {
    static let badge = "badge-element-kind"
    static let background = "background-element-kind"
    static let sectionHeader = "section-header-element-kind"
    static let sectionFooter = "section-footer-element-kind"
}

class HomeViewController: UICollectionViewController {
    let disposeBag = DisposeBag()
    
    var dailyList: [MovieInfo] = []
    var weeklyList: [MovieInfo] = []
    var boxOfficeInfo: [String: Movie] = [:]
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil) //임시 아이콘
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: nil, action: nil)
        
        let temp = UICollectionViewFlowLayout()
        let vc = MovieSearchViewController(collectionViewLayout: temp)
        let nav = UINavigationController(rootViewController: vc)
        searchController = UISearchController(searchResultsController: nav)
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.delegate = vc.self
        self.navigationItem.searchController = searchController
        
        
        
        collectionView.register(BoxOfficeCell.self, forCellWithReuseIdentifier: "BoxOfficeCell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: ElementKind.sectionHeader, withReuseIdentifier: "CollectionViewHeader")
        collectionView.register(BoxOfficeBadge.self, forSupplementaryViewOfKind: ElementKind.badge, withReuseIdentifier: "BoxOfficeBadge")
        collectionView.collectionViewLayout = BoxOfficeCompositionalLayout().layout()
        
        getDataAsync()
    }
    private func getDataAsync() {
        Task {
            do {
                async let daily = APIManager().searchBoxOfficeInfo(dateRange: .daily)
                async let weekly = APIManager().searchBoxOfficeInfo(dateRange: .weekly)
                let movies = try await [daily, weekly]
                //BoxOffice 일간 주간 리스트
                dailyList = movies[0]
                weeklyList = movies[1]
                //boxOfficeInfo에서 영화이름을 Key로 포스터를 가져오거나 상세 정보를 표시.
                boxOfficeInfo = try await loadMovieDetail(movies: dailyList + weeklyList)
                collectionView.reloadData()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    private func loadMovieDetail(movies: [MovieInfo]) async throws -> [String: Movie] {
        var temp: [String: Movie] = [:]
        try await withThrowingTaskGroup(of: (String, Movie?).self) { group in
            for movie in (dailyList + weeklyList) {
                group.addTask {
                    return try await (movie.movieNm,
                                      APIManager().searchMovieInfo(title: movie.movieNm, releaseDate: nil))
                }
            }
            for try await (name, movie) in group {
                guard let movie else { continue }
                temp[name] = movie
            }
        }
        return temp
    }
    func getPosterImage(title: String) -> String {
        guard let temp = boxOfficeInfo[title] else {
            return ""
        }
        let posters = temp.posters.components(separatedBy: "|")
        return posters[0]
    }
}

// SwiftUI Preview Provider
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let layout = UICollectionViewFlowLayout()
            let vc = HomeViewController(collectionViewLayout: layout)
            return UINavigationController(rootViewController: vc)
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
