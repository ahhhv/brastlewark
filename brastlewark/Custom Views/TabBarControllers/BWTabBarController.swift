//
//  BWTabBarController.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemRed
        viewControllers = [createPeopleNC(), createFavoritesNC()]
    }
    
    func createPeopleNC() -> UINavigationController {
        let searchVC = PeopleListVC()
        searchVC.title = "Brastlewark"
        
        searchVC.tabBarItem.image = UIImage(systemName: "person.3")
        searchVC.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        
        return UINavigationController(rootViewController: searchVC)
    }
        
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favorites"
        favoritesListVC.tabBarItem.image = UIImage(systemName: "star.square")
        favoritesListVC.tabBarItem.selectedImage = UIImage(systemName: "star.square.fill")
        favoritesListVC.tabBarItem.tag = 1
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
}
