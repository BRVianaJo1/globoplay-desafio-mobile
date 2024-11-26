//
//  HomePresenter.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

protocol HomePresentationLogic {
    func presentScreenValues(response: [Home.Model.Result])
}

final class HomePresenter: HomePresentationLogic {
    
    // MARK: - Archtecture Objects
    
    weak var viewController: HomeDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentScreenValues(response: [Home.Model.Result]) {
        let genreList = parseCarouselMoviesFrom(response: response)
        viewController?.displayScreenValues(genreList: genreList)
    }
    
    func parseCarouselMoviesFrom(response: [Home.Model.Result]) -> [GenreList] {
        let mappedList = response.map { item in
            CarouselMovies(genere: item.genreIDS.first?.name ?? "Sem Gênero", imageURL: "https://image.tmdb.org/t/p/w500\(item.posterPath)", id: item.id, title: item.title)
        }
        let genreList = Dictionary(grouping: mappedList, by: { $0.genere })
        var genreArray : [GenreList] = []
        for (key, value) in genreList {
            genreArray.append(GenreList(genre: key, movies: value))
        }
        let sortedGenreArray = genreArray.sorted { $0.movies.count > $1.movies.count }
        return sortedGenreArray
    }
}
