//
//  DetailsPresenter.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

protocol DetailsPresentationLogic {
    func presentScreenValues(movie: Details.Model.Response)
}

final class DetailsPresenter: DetailsPresentationLogic {
    
    // MARK: - Archtecture Objects
    
    weak var viewController: DetailsDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentScreenValues(movie: Details.Model.Response) {
        viewController?.displayScreenValues(movie: movie)
    }
}
