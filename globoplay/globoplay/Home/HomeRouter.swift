//
//  HomeRouter.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

@objc protocol HomeRoutingLogic {
    func routeToDetails(idMovie: Int)
}

final class HomeRouter: NSObject, HomeRoutingLogic {
    
    // MARK: - Archtecture Objects
    
    weak var viewController: HomeViewController?
    
    // MARK: - Routing Logic
    
    func routeToDetails(idMovie: Int) {
        let nextViewController = DetailsViewController(idMovie: idMovie)
        nextViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
