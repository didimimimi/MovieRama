//
//  MovieListStates.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

enum MovieListStates {
    case createList(movies: [Movie]) // replace movies in main list
    case appendToList(movies: [Movie], indexPaths: [IndexPath]) // append new page of movies in main list
    case moveToDetailsScreen(ofMovie: Movie)
    case loadingState(show: Bool)
}
