//
//  MainTabBarViewController.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 17/1/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .systemBackground
        
        viewControllers = [createHomeVC(), createSourceVC(), createFavoritesVC()]
        
    }
    
    private func createHomeVC() -> UINavigationController {
        
        let homeVC = HomeViewController()
        homeVC.title = "News"
        homeVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func createSourceVC() -> UINavigationController {
        
        let sourceVC = SourceViewController()
        sourceVC.title = "News Sources"
        sourceVC.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        
        return UINavigationController(rootViewController: sourceVC)
    }
    
    private func createFavoritesVC() -> UINavigationController {
        
        let favortiesVC = FavoritesViewController()
        favortiesVC.title = "Favorites"
        favortiesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        favortiesVC.tabBarItem = UITabBarItem(title: "Boolmark", image: UIImage(systemName: "bookmark"), tag: 2)
        
        return UINavigationController(rootViewController: favortiesVC)
    }

}
