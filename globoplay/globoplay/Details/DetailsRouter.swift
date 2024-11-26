//
//  DetailsRouter.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

@objc protocol DetailsRoutingLogic {
    func routeToPlayerVideo(key: String)
}

protocol DetailsDataPassing {
    var dataStore: DetailsDataStore? { get }
}

final class DetailsRouter: NSObject, DetailsRoutingLogic, DetailsDataPassing {
    
    // MARK: - Archtecture Objects
    
    weak var viewController: DetailsViewController?
    var dataStore: DetailsDataStore?
    
    // MARK: - Routing Logic

    func routeToPlayerVideo(key: String) {
        let nextViewController = PlayerVideoViewController(videoURL: "https://youtube.com/watch?v=\(key)")
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
