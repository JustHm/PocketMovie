//
//  HomeViewController.swift
//  PocketMovie
//
//  Created by 안정흠 on 2022/11/25.
//

import UIKit
import SwiftUI

class HomeViewController: UICollectionViewController {
    var dailyList: [BoxOffice] = []
    var weeklyList: [BoxOffice] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil) //임시 아이콘
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: nil, action: nil)
        
        // MARK: PARSING TEST
        do {
            let fileLocation = Bundle.main.url(forResource: "temp", withExtension: "json")!
            let data = try Data(contentsOf: fileLocation)
            let result = try JSONDecoder().decode(BoxOffice.self, from: data)
            print(result)
        } catch {
            print("ERROR \(error.localizedDescription)")
        }
        // MARK: END
        APIService.shared.boxOfficeResponse(range: .daily, completion: { response in
            
        })
        APIService.shared.boxOfficeResponse(range: .weekly, completion: { response in
            
        })
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
