//
//  MovieListViewModel.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

protocol MovieListViewModelDelegate: AnyObject {
    func update(state: MovieListStates)
}

class MovieListViewModel: MovieListIntents {
    private var movies = [Movie]()
    private var searchResults = [Movie]()
    
    private weak var delegate: MovieListViewModelDelegate?
    
    init(delegate: MovieListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func searchMovie(text: String) {
        
    }
    
    func movieTapped(movie: Movie) {
        
    }
    
    func favoriteTapped(movie: Movie) {
        
    }
}
