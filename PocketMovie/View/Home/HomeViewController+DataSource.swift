//
//  HomeViewController+DataSource.swift
//  PocketMovie
//
//  Created by 안정흠 on 2023/03/23.
//

import UIKit
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

