//
//  HomeInteractor.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

protocol HomeBusinessLogic {
   func fetchData(type: String)
}

final class HomeInteractor: HomeBusinessLogic {
    
    // MARK: - Archtecture Objects
    
    var presenter: HomePresentationLogic?
    private let apiService: APIService
    
    private var data: [Home.Model.Result]?
    private var error: NSError?
    
    // MARK: - Interactor Lifecycle
    
    init(apiService: APIService = APIProvider.shared) {
        self.apiService = apiService
    }
    
    func fetchData(type: String) {
        self.apiService.fetchMovies(from: type) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.data = response.results
                loadScreenValues()
                self.apiService.fetchMyList() { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let response):
                        self.data = response.results
                        let movieIDs = response.results.map { $0.id }
                        WatchlistFactory.shared.updateWatchlist(with: movieIDs)
                    case .failure(let error):
                        self.error = error as NSError
                        print(error)
                    }
                }
            case .failure(let error):
                self.error = error as NSError
                print(error)
            }
        }
    }

    
    // MARK: - Business Logic
    
    func loadScreenValues() {
        guard let movies = data else { return }
        presenter?.presentScreenValues(response: movies)
    }
}
