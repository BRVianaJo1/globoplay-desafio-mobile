//
//  MyListRouter.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 20/11/24.
//

import UIKit

@objc protocol MyListRoutingLogic {
    func routeToDetails(idMovie: Int)
}

final class MyListRouter: NSObject, MyListRoutingLogic {
    
    // MARK: - Archtecture Objects
    
    weak var viewController: MyListViewController?
    
    // MARK: - Routing Logic
    
    func routeToDetails(idMovie: Int) {
        let nextViewController = DetailsViewController(idMovie: idMovie)
        nextViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
