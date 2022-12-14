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
        
        getRankData()
        rxResponse()
        
        collectionView.register(BoxOfficeCell.self, forCellWithReuseIdentifier: "BoxOfficeCell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: ElementKind.sectionHeader, withReuseIdentifier: "CollectionViewHeader")
        collectionView.register(BoxOfficeBadge.self, forSupplementaryViewOfKind: ElementKind.badge, withReuseIdentifier: "BoxOfficeBadge")
        collectionView.collectionViewLayout = layout()
        //        collectionView.refreshControl =
        
    }
    private func rxResponse() {
        let weeklyData = PublishSubject<[MovieInfo]>()
        let dailyData = PublishSubject<[MovieInfo]>()
        APIService.shared.boxOfficeResponseWithRx(range: .daily)
            .compactMap{ response in
                if let temp = response.boxOfficeResult.dailyBoxOfficeList {
                    return temp
                }
                return nil
            }
            .bind(to: dailyData)
            .disposed(by: disposeBag)
        APIService.shared.boxOfficeResponseWithRx(range: .weekly)
            .compactMap{ response in
                if let temp = response.boxOfficeResult.weeklyBoxOfficeList {
                    return temp
                }
                return nil
            }
            .bind(to: weeklyData)
            .disposed(by: disposeBag)
        
        let cellData: Driver<[MovieInfo]>
        cellData = dailyData.asDriver(onErrorJustReturn: [])
        cellData
            .drive(collectionView.rx.items(cellIdentifier: "BoxOfficeCell", cellType: BoxOfficeCell.self)) { index, data, cell in
                
            
        }
        print("HERE: \(cellData)")
    }
    
    private func getRankData() {
        APIService.shared.boxOfficeResponse(range: .daily, completion: { [weak self] response in
            guard let data = response.boxOfficeResult.dailyBoxOfficeList else {return}
            self?.dailyList = data
            self?.getMovieInfo()
        })
        APIService.shared.boxOfficeResponse(range: .weekly, completion: {[weak self] response in
            guard let data = response.boxOfficeResult.weeklyBoxOfficeList else {return}
            self?.weeklyList = data
            self?.getMovieInfo()
        })
    }
    
    private func getMovieInfo() {
        for (_, value) in dailyList.enumerated() {
            requsetMovieInfo(value: value)
        }
        for (_, value) in weeklyList.enumerated() {
            requsetMovieInfo(value: value)
        }
    }
    private func requsetMovieInfo(value: MovieInfo) {
        guard boxOfficeInfo[value.movieNm] != nil else {
            APIService.shared.searchMovie(title: value.movieNm, releaseDate: value.openDt, startCount: 0, completion: { [weak self] response in
                if let temp = response.result {
                    self?.boxOfficeInfo[value.movieNm] = temp[0]
                    self?.collectionView.reloadData()
                }
            })
            return
        }
    }
    private func getPosterImage(title: String) -> String {
        guard let temp = boxOfficeInfo[title] else {
            return ""
        }
        let posters = temp.posters.components(separatedBy: "|")
        return posters[0]
    }
}
// MARK: CompositionalLayout Settings
extension HomeViewController {
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: boxOfficeSection())
    }
    
    private func boxOfficeSection() -> NSCollectionLayoutSection {
        // layout
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize,supplementaryItems: [createGroupBadge()])
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5)
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(500), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 15, trailing: 5)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    // create badge
    private func createGroupBadge() -> NSCollectionLayoutSupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .estimated(24), heightDimension: .estimated(24))
        let anchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0, y: -1))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: layoutSize, elementKind: ElementKind.badge, containerAnchor: anchor)
        return badge
    }
    // sectionHeader Layout settings
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Header Size
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        // Section Header Layout
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: ElementKind.sectionHeader, alignment: .top)
        
        return sectionHeader
    }
}
// MARK: UICollectionViewDataSource
extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: // daily
            return dailyList.count
        case 1:
            return weeklyList.count
        default:
            return 0
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoxOfficeCell", for: indexPath) as? BoxOfficeCell else { return UICollectionViewCell() }
        switch indexPath.section {
        case 0:
            let data = dailyList[indexPath.row]
            let poster = getPosterImage(title: data.movieNm)
            cell.setup(imageURL: poster, rank: data.rank)
            return cell
        case 1:
            let data = weeklyList[indexPath.row]
            let poster = getPosterImage(title: data.movieNm)
            cell.setup(imageURL: poster, rank: data.rank)
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == ElementKind.sectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath) as? CollectionViewHeader else { return UICollectionReusableView() }
            switch indexPath.section {
            case 0:
                headerView.headerLabel.text = "일간 박스 오피스 순위"
            case 1:
                headerView.headerLabel.text = "주간 박스 오피스 순위"
            default:
                return UICollectionReusableView()
            }
            return headerView
        }
        else if kind == ElementKind.badge {
            guard let badge = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BoxOfficeBadge", for: indexPath) as? BoxOfficeBadge else { return UICollectionReusableView() }
            
            switch indexPath.section {
            case 0:
                let data = dailyList[indexPath.row]
                badge.setup(text: data.rankOldAndNew)
            case 1:
                let data = weeklyList[indexPath.row]
                badge.setup(text: data.rankOldAndNew)
            default:
                return UICollectionReusableView()
            }
            return badge
        }
        else {
            return UICollectionReusableView()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedMovie = ""
        
        switch indexPath.section {
        case 0:
            selectedMovie = dailyList[indexPath.row].movieNm
        case 1:
            selectedMovie = weeklyList[indexPath.row].movieNm
        default:
            return
        }
        
        let vc = MovieDetailViewController()
        vc.setup(data: boxOfficeInfo[selectedMovie]!)
        
        navigationController?.pushViewController(vc, animated: true)
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
