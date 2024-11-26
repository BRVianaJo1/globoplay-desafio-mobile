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
            let backdropPath: String
            let genres: [Genre]
            let id: Int
            let originCountry: [String]
            let originalLanguage, originalTitle, overview: String
            let popularity: Double
            let posterPath: String
            let productionCompanies: [ProductionCompany]
            let releaseDate: String
            let spokenLanguages: [SpokenLanguage]
            let status, tagline, title: String
            let voteAverage: Double
            let voteCount: Int
            let videos: Videos

            enum CodingKeys: String, CodingKey {
                case backdropPath = "backdrop_path"
                case genres, id
                case originCountry = "origin_country"
                case originalLanguage = "original_language"
                case originalTitle = "original_title"
                case overview, popularity
                case posterPath = "poster_path"
                case productionCompanies = "production_companies"
                case releaseDate = "release_date"
                case spokenLanguages = "spoken_languages"
                case status, tagline, title
                case voteAverage = "vote_average"
                case voteCount = "vote_count"
                case videos
            }
        }
        
        // MARK: - Genre
        struct Genre: Codable {
            let id: Int
            let name: String
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

        // MARK: - ProductionCountry
        struct ProductionCountry: Codable {
            let iso3166_1, name: String

            enum CodingKeys: String, CodingKey {
                case iso3166_1 = "iso_3166_1"
                case name
            }
        }

        // MARK: - SpokenLanguage
        struct SpokenLanguage: Codable {
            let englishName, iso639_1, name: String

            enum CodingKeys: String, CodingKey {
                case englishName = "english_name"
                case iso639_1 = "iso_639_1"
                case name
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
