//
//  MovieListStates.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

enum MovieListStates {
    case updateList(movies: [Movie], searchResults: [Movie]?)
    case favoriteUpdated(forMovie: Movie)
    case moveToDetailsScreen(ofMovie: Movie)
}
