//
//  DetailsModels.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

enum Details {
    enum Model {
        // MARK: - Response
        struct Response: Codable {
            let id: Int
            let originCountry: [String]
            let originalLanguage, overview: String
            let posterPath: String
            let productionCompanies: [ProductionCompany]
            let releaseDate: String
            let title: String
            let voteAverage: Double
            let videos: Videos

            enum CodingKeys: String, CodingKey {
                case id
                case originCountry = "origin_country"
                case originalLanguage = "original_language"
                case overview
                case posterPath = "poster_path"
                case productionCompanies = "production_companies"
                case releaseDate = "release_date"
                case title
                case voteAverage = "vote_average"
                case videos
            }
        }

        // MARK: - ProductionCompany
        struct ProductionCompany: Codable {
            let id: Int
            let logoPath: String?
            let name, originCountry: String

            enum CodingKeys: String, CodingKey {
                case id
                case logoPath = "logo_path"
                case name
                case originCountry = "origin_country"
            }
        }
        
        // MARK: - Videos
        struct Videos: Codable {
            let results: [Result]
        }
        
        // MARK: - Result
        struct Result: Codable {
            let key: String
            let site: String
            let type: String?
        }
    }
}

    // MARK: - Welcome
    struct WatchListResponse: Codable {
        let success: Bool
        let statusCode: Int
        let statusMessage: String

        enum CodingKeys: String, CodingKey {
            case success
            case statusCode = "status_code"
            case statusMessage = "status_message"
        }
    }
