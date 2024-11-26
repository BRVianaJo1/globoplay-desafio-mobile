//
//  DetailsInteractor.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

protocol DetailsBusinessLogic {
    func fetchData(id: Int)
    func addToMyList(id: Int, addToWatchlist: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol DetailsDataStore {
    // var name: String { get set }
}

final class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {
    
    // MARK: - Archtecture Objects
    
    var presenter: DetailsPresentationLogic?
    private let apiService: APIService
    
    private var data: Details.Model.Response?
    private var watchListData: WatchListResponse?
    private var error: NSError?
    
    
    // MARK: - DataStore Objects
    
    // var name: String = ""
    
    // MARK: - Interactor Lifecycle
    
    init(apiService: APIService = APIProvider.shared) {
        self.apiService = apiService
    }
    
    func fetchData(id: Int) {
        self.apiService.fetchMyDetails(id: id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.data = response
                loadScreenValues()
            case .failure(let error):
                self.error = error as NSError
                print(error)
            }
        }
    }
    
    func addToMyList(id: Int, addToWatchlist: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        self.apiService.addWatchList(id: id, addToWatchlist: addToWatchlist) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.watchListData = response
                loadScreenValues()
                completion(.success(()))
            case .failure(let error):
                self.error = error as NSError
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Business Logic
    
    func loadScreenValues() {
        guard let movie = data else { return }
        presenter?.presentScreenValues(movie: movie)
    }
}
