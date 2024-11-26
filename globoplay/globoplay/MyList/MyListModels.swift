//
//  MyListModels.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 20/11/24.
//

import UIKit

enum MyList {
    enum Model {
        // MARK: - Response
        struct Response: Codable {
            let results: [Result]
        }

        // MARK: - Result
        struct Result: Codable {
            let genreIDS: [Int]
            let id: Int
            let overview: String
            let posterPath, title: String

            enum CodingKeys: String, CodingKey {
                case genreIDS = "genre_ids"
                case id
                case overview
                case posterPath = "poster_path"
                case title
            }
        }
    }
}
