//
//  HomeWorker.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

protocol HomeWorkerLogic {
    func fetchData(completion: (Result<Home.Model.Response, APIError>))
}

//final class HomeWorker: HomeWorkerLogic {
//    
//    private let apiService: APIService
//    
//    init(apiService: APIService = APIProvider.shared) {
//        self.apiService = apiService
//    }
//    
//    func fetchData(completion: (Result<Home.Model.Response, APIError>)) {
//        self.apiService.fetchAll() { [weak self] (result) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                return response
//                
//            case .failure(let error):
//                self.error = error as NSError
//            }
//        }
//    }
//}

