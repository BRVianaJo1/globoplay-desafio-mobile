//
//  ViewController.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//


import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = GloboColors.white
        self.tabBar.unselectedItemTintColor = GloboColors.secondaryGray
        self.tabBar.barTintColor = GloboColors.black
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 0

        let homeViewController = HomeViewController()
        let myListViewController = MyListViewController()

        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let myListNavigationController = UINavigationController(rootViewController: myListViewController)

        homeNavigationController.tabBarItem = UITabBarItem(
            title: HomeKeys.Localized.homeButtonTitle.rawValue,
            image: UIImage(named: HomeKeys.Localized.homeImage.rawValue),
            selectedImage: UIImage(named: HomeKeys.Localized.homeImage.rawValue)
        )
        myListNavigationController.tabBarItem = UITabBarItem(
            title: HomeKeys.Localized.myListButtonTitle.rawValue,
            image: UIImage(named: HomeKeys.Localized.myListImage.rawValue),
            selectedImage: UIImage(named: HomeKeys.Localized.myListImage.rawValue)
        )

        self.viewControllers = [homeNavigationController, myListNavigationController]
    }
}
