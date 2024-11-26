//
//  WatchlistFactory.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 25/11/24.
//

import Foundation

class WatchlistFactory {
    static let shared = WatchlistFactory()
    
    private var watchlistMovies: [Int] = []
    
    private init() {}
    
  
    func updateWatchlist(with movieIDs: [Int]) {
        self.watchlistMovies = movieIDs
    }

    func isMovieInWatchlist(movieID: Int) -> Bool {
        return watchlistMovies.contains(movieID)
    }
}

