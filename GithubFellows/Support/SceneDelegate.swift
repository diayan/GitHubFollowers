//
//  SceneDelegate.swift
//  GithubFellows
//
//  Created by diayan siat on 09/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
    }
    
    //search navigation controller for the SearchViewController
    func createSeachNavigationController() -> UINavigationController {
        let searchViewcontroller = SearchViewController()
        searchViewcontroller.title = "Search"
        searchViewcontroller.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchViewcontroller)
    }
    
    //favoriteNavigationController for the FavoriteListViewController
    func favoriteNavigationViewController() -> UINavigationController {
        let favoriteViewController = FavoritListViewController()
        favoriteViewController.title = "Favorites"
        favoriteViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoriteViewController)
    }
    
    //create and initialize a tab bar
    func createTabBar() -> UITabBarController {
        let tabbar = UITabBarController() //initialize UITabBarController
        UITabBar.appearance().tintColor = .systemGreen //add tint color to tab bar
        //add seachNavController and favoriteNavController to the tab bar
        tabbar.viewControllers = [createSeachNavigationController(), favoriteNavigationViewController()]
        return tabbar
        
    }
    
    //configure all navigation bar items to be green 
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

