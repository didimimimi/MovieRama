//
//  MovieListIntents.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

protocol MovieListIntents: AnyObject {
    func searchMovie(text: String)
    func movieTapped(movie: Movie, indexPath: IndexPath)
    func favoriteTapped(movie: Movie, indexPath: IndexPath, favorite: Bool)
    func scrolledToBottom()
    func refresh()
}
