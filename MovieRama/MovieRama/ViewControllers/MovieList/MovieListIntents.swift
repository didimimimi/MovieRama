//
//  MovieListIntents.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

protocol MovieListIntents: AnyObject {
    func searchMovie(text: String)
    func movieTapped(movie: Movie)
    func favoriteTapped(movie: Movie, favorite: Bool)
    func getMoreMovies()
}
