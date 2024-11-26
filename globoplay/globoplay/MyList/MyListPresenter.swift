//
//  MyListPresenter.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 20/11/24.
//

import UIKit

protocol MyListPresentationLogic {
    func presentScreenValues(response: [Home.Model.Result])
}

final class MyListPresenter: MyListPresentationLogic {
    
    // MARK: - Archtecture Objects
    
    weak var viewController: MyListDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentScreenValues(response: [Home.Model.Result]) {
        viewController?.displayScreenValues(movieList: response)
    }
}
