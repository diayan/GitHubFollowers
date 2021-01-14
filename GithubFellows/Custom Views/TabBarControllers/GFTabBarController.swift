//
//  GFTabBarController.swift
//  GithubFellows
//
//  Created by diayan siat on 28/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen //add tint color to tab bar
        viewControllers                 = [createSeachNavigationController(), favoriteNavigationViewController()]
    }
    
    //search navigation controller for the SearchViewController
    func createSeachNavigationController() -> UINavigationController {
        let searchViewcontroller        = SearchViewController()
        searchViewcontroller.title      = "Search"
        searchViewcontroller.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchViewcontroller)
    }
    
    //favoriteNavigationController for the FavoriteListViewController
    func favoriteNavigationViewController() -> UINavigationController {
        let favoriteViewController        = FavoritListViewController()
        favoriteViewController.title      = "Favorites"
        favoriteViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteViewController)
    }
}
