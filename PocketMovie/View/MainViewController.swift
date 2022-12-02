//
//  MainViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/12/02.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    var subVC = UIViewController()
    let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.hidesBarsOnSwipe = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil) //임시 아이콘
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: nil, action: nil)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Movie"
        self.navigationItem.searchController = searchController
        
        initSubView()
        
        
       
    }
    private func initSubView() {
        let layout = UICollectionViewFlowLayout()
        subVC = HomeViewController(collectionViewLayout: layout)
        
        self.addChild(subVC)
        self.view.addSubview(subVC.view)
        self.didMove(toParent: self)
        
        subVC.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    private func releaseSubView() {
        subVC.willMove(toParent: nil) // 제거되기 직전에 호출
        subVC.removeFromParent() // parentVC로 부터 관계 삭제
        subVC.view.removeFromSuperview() // parentVC.view.addsubView()와 반대 기능
    }
    
}

// SwiftUI Preview Provider
struct MainViewController_Preview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = MainViewController()
            return UINavigationController(rootViewController: vc)
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
}
