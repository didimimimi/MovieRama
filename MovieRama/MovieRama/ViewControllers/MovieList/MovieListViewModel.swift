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
    
    private var pagination: MovieListPagination?
    private var searchMoviesPagination: MovieListPagination?
    
    private weak var delegate: MovieListViewModelDelegate?
    
    private var mode = MainScreenListMode.showAllMovies
    
    init(delegate: MovieListViewModelDelegate) {
        self.delegate = delegate
        
        self.getAllMovies()
    }
    
    init() {}
    
    private func getAllMovies() {
        self.delegate?.update(state: .loadingState(show: true))
        // TODO: API Call for movies and setting them to movies, self.movies = response
        
        // TODO: remove mock data
        self.movies = MovieRamaHelper().setUpMockMovies()
        
        self.delegate?.update(state: .loadingState(show: false))
        
        self.switchModeToAllMoviesMode()
    }
    
    func searchMovie(text: String) {
        if text.isEmpty {
            self.switchModeToAllMoviesMode()
        } else {
            self.performSearch(text: text)
        }
    }
    
    private func performSearch(text: String) {
        self.delegate?.update(state: .loadingState(show: true))
        // TODO: API Call for searching movies and setting them to searchResults, self.searchResults = response
        
        // TODO: remove custom search
        self.searchResults = self.movies.filter( { $0.title?.contains(text) == true })
        
        self.delegate?.update(state: .loadingState(show: false))

        self.switchModeToSearchResultsMode()
    }
    
    func movieTapped(movie: Movie) {
        self.delegate?.update(state: .moveToDetailsScreen(ofMovie: movie))
    }
    
    func favoriteTapped(movie: Movie, favorite: Bool) {
        movie.favorite = favorite
        MovieRamaHelper().saveFavoriteInfoToDevice(ofMovie: movie)
    }
    
    func getMoreMovies() {
        let selectedPagination = (self.mode == .showAllMovies) ? self.pagination : self.searchMoviesPagination
        let moviesForScreen = selectedPagination?.getNextPageData()?.page ?? []
        let newIndexPaths = selectedPagination?.getNextPageData()?.indexPathsToAppend ?? []
        
        self.delegate?.update(state: .appendToList(movies: moviesForScreen, indexPaths: newIndexPaths))
    }
    
    private func switchModeToAllMoviesMode() {
        let moviesForScreen = self.switchModeAndGetNextPage(to: .showAllMovies)
        self.delegate?.update(state: .createList(movies: moviesForScreen))
    }
    
    private func switchModeToSearchResultsMode() {
        let moviesForScreen = self.switchModeAndGetNextPage(to: .showSearchResults)
        self.delegate?.update(state: .createList(movies: moviesForScreen))
    }
    
    private func switchModeAndGetNextPage(to mode: MainScreenListMode) -> MoviePage {
        self.mode = mode
        
        var selectedPagination = (self.mode == .showAllMovies) ? self.pagination : self.searchMoviesPagination
        let selectedMovies = (self.mode == .showAllMovies) ? self.movies : self.searchResults
        
        selectedPagination = MovieListPagination(movies: selectedMovies,
                                                 moviesPerPage: MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE)
        return selectedPagination?.getNextPageData()?.page ?? []
    }
}
