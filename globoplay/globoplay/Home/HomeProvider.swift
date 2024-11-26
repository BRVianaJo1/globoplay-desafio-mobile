//
//  HomeProvider.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 20/11/24.
//

import Foundation

class HomeProvider: HomeWorker {
    
    static let shared = HomeWorker()
    private  init() {
        
    }
    var httpMethod: RequestHTTPMethod { .get }
    private let apiKey = "APIKEY"
    private let apiUrl = ""
    private let urlSession = URLSession.shared
}
