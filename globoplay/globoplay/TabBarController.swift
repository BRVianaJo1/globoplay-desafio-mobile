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

        // Instanciar os ViewControllers
        let homeViewController = HomeViewController()
        let myListViewController = MyListViewController()

        // Envolver os ViewControllers em UINavigationControllers
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let myListNavigationController = UINavigationController(rootViewController: myListViewController)

        // Atribuir itens do tabBar
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

        // Atribuir o array de UINavigationControllers ao UITabBarController
        self.viewControllers = [homeNavigationController, myListNavigationController]
    }
}
