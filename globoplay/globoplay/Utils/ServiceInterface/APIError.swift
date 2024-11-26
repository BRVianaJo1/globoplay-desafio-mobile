//
//  APIError.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 21/11/24.
//

import Foundation

enum APIError: Error {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Falha na API"
        case .invalidEndpoint: return "Endpoint inválido"
        case .invalidResponse: return "Response Inválido"
        case .noData: return "Sem dados"
        case .serializationError: return "Serialization Error"
        }
    }
}
