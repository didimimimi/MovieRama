//
//  MovieListStates.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

enum MovieListStates {
    case createListState(movies: [Movie]) // replace movies in main list
    case appendToListState(movies: [Movie], indexPaths: [IndexPath]) // append new page of movies in main list
    case noMoreMoviesState // reached the bottom and all movies have been loaded
    case moveToDetailsScreenState(ofMovie: Movie) // movie pressed
    case endRefreshState // end refresh control animation
    case refreshListState(indexPath: IndexPath) // refresh rows in order to update the images
    case emptyListState // no lists to load
    case addLoadingCellState // adds loading cell at the bottom
    case removeLoadingCellState // removes loading cell at the bottom
}
