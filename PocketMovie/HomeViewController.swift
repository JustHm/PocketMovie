//
//  HomeViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import UIKit
import SwiftUI

class HomeViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PocketMovie"
        navigationController?.navigationBar.prefersLargeTitles = true
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
