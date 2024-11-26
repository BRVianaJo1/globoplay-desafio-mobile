//
//  APIService.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 20/11/24.
//

import Foundation

protocol APIService {
    
    func fetchMovies(from endpoint: String, completion: @escaping (Result<Home.Model.Response, APIError>) -> ())
    func fetchMyList(completion: @escaping (Result<Home.Model.Response, APIError>) -> ())
    func addWatchList(id: Int, addToWatchlist: Bool, completion: @escaping (Result<WatchListResponse, APIError>) -> ())
    func fetchMyDetails(id: Int, completion: @escaping (Result<Details.Model.Response, APIError>) -> ())
}

enum APIError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Falha para obter os dados!"
        case .invalidEndpoint: return "Endpoint Inválido!"
        case .invalidResponse: return "Response Inválido!"
        case .noData: return "Sem dados!"
        case .serializationError: return "Falha para decodificar os dados na model!"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
