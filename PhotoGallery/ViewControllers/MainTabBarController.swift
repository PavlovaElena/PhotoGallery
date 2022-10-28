//
//  MainTabBarController.swift
//  PhotoGallery
//
//  Created by Elena Pavlova on 26.10.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let layout = UICollectionViewFlowLayout()
        let photosVC = PhotosCollectionViewController(collectionViewLayout: layout)
        
        viewControllers = [
            createNavigationController(
                rootViewController: photosVC,
                title: "Photos",
                image: UIImage(systemName: "photo.on.rectangle.angled")!
            ),
            createNavigationController(
                rootViewController: ViewController(),
                title: "Favorites",
                image: UIImage(systemName: "heart.rectangle")!
            )
        ]
        
        tabBar.tintColor = .black
    }
    
    private func createNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
