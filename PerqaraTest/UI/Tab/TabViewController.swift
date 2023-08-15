//
//  TabViewController.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit

class TabViewController: UITabBarController {
    
    lazy var listGamesNavController: UINavigationController = {
        let listGamesViewController = ListGamesViewController()
        let navController = UINavigationController(rootViewController: listGamesViewController)
        navController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        return navController
    }()
    
    lazy var listFavoritesNavController: UINavigationController = {
        let listFavoritesViewController = ListFavoritesViewController()
        let navController = UINavigationController(rootViewController: listFavoritesViewController)
        navController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 0)
        return navController
    }()
    
    private var tabItems: [UIViewController] {
        return [listGamesNavController, listFavoritesNavController]
    }
    
    private let titleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBar()
    }

}

// MARK: - Helpers

extension TabViewController {
    private func configTabBar() {
        tabBar.barTintColor = .mainBlue
        tabBar.backgroundColor = .tabGray
        tabBar.tintColor = .mainBlue
        tabBar.isTranslucent = false
        tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        viewControllers = tabItems
    }
}
