//
//  HomeModels.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

enum Home {
    enum Model {
        // MARK: - Response
        struct Response: Decodable {
            let results: [Result]
        }
        
        // MARK: - Result
        struct Result: Decodable {
            let genreIDS: [MovieGenre]
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
        
        enum MovieGenre: (Int), Codable {
           
            case action = 28
            case adventure = 12
            case animation = 16
            case comedy = 35
            case crime = 80
            case documentary = 99
            case drama = 18
            case family = 10751
            case fantasy = 14
            case history = 36
            case horror = 27
            case music = 10402
            case mystery = 9648
            case romance = 10749
            case scienceFiction = 878
            case tvMovie = 10770
            case thriller = 53
            case war = 10752
            case western = 37
            
            
            var name: String {
                switch self {
                case .action:
                    return "Ação"
                case .adventure:
                    return "Aventura"
                case .animation:
                    return "Animação"
                case .comedy:
                    return "Comédia"
                case .crime:
                    return "Crimes"
                case .documentary:
                    return "Documentário"
                case .drama:
                    return "Drama"
                case .family:
                    return "Família"
                case .fantasy:
                    return "Fantasia"
                case .history:
                    return "História"
                case .horror:
                    return "Horror"
                case .music:
                    return "Musical"
                case .mystery:
                    return "Mistério"
                case .romance:
                    return "Romance"
                case .scienceFiction:
                    return "Ficção Científica"
                case .tvMovie:
                    return "Filme de TV"
                case .thriller:
                    return "Terror"
                case .war:
                    return "Guerra"
                case .western:
                    return "Faroeste"
                }
            }
        }
    }
}

struct GenreList {
    let genre: String
    let movies: [CarouselMovies]
}

struct CarouselMovies {
    let genere: String
    let imageURL: String?
    let id: Int
    let title: String
}
