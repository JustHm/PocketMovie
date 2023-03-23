//
//  BoxOfficeCompositionalLayout.swift
//  PocketMovie
//
//  Created by 안정흠 on 2023/02/07.
//

import UIKit

// MARK: CompositionalLayout Settings
struct BoxOfficeCompositionalLayout {
    func layout() -> UICollectionViewCompositionalLayout {
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
