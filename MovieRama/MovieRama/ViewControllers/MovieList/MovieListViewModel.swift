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
        
        self.loadMoviesFromSplashScreen()
    }
    
    init() {}
    
    private func loadMoviesFromSplashScreen() {
        self.movies = MovieRamaSingleton.sharedInstance.moviesFromSplashScreen
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
        // TODO: API Call for searching movies and setting them to searchResults, self.searchResults = response
        
        // TODO: remove custom search
        self.searchResults = self.movies.filter( { $0.title?.contains(text) == true })
        
        self.switchModeToSearchResultsMode()
    }
    
    func movieTapped(movie: Movie) {
        self.delegate?.update(state: .moveToDetailsScreenState(ofMovie: movie))
    }
    
    func favoriteTapped(movie: Movie, favorite: Bool) {
        movie.favorite = favorite
        MovieRamaHelper().saveFavoriteInfoToDevice(ofMovie: movie)
    }
    
    func loadMoreMovies() {
        let paginationResult: (page: MoviePage, indexPathsToAppend: [IndexPath])?
        
        switch self.mode {
        case .showAllMovies:
            paginationResult = self.pagination?.getNextPageData()
        case.showSearchResults:
            paginationResult = self.searchMoviesPagination?.getNextPageData()
        }
        
        guard let paginationResult = paginationResult else {
            return
        }
        
        let moviesForScreen = paginationResult.page
        let newIndexPaths = paginationResult.indexPathsToAppend
        
        self.delegate?.update(state: .appendToListState(movies: moviesForScreen, indexPaths: newIndexPaths))
    }
    
    private func switchModeToAllMoviesMode() {
        self.switchModeAndGetNextPage(to: .showAllMovies)
    }
    
    private func switchModeToSearchResultsMode() {
        self.switchModeAndGetNextPage(to: .showSearchResults)
    }
    
    private func switchModeAndGetNextPage(to mode: MainScreenListMode) {
        self.mode = mode
        let selectedPagination: MovieListPagination?
        
        switch self.mode {
        case .showAllMovies:
            self.pagination = MovieListPagination(movies: self.movies,
                                                  moviesPerPage: MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE)
            selectedPagination = self.pagination
        case .showSearchResults:
            self.searchMoviesPagination = MovieListPagination(movies: self.searchResults,
                                                              moviesPerPage: MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE)
            selectedPagination = self.searchMoviesPagination
        }
        
        let moviesForScreen = selectedPagination?.getNextPageData()?.page ?? []
        self.delegate?.update(state: .createListState(movies: moviesForScreen))
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // TODO: API Call for movies and setting them to movies, self.movies = response
            self.movies = MovieRamaHelper().setUpMockMovies()
            
            MovieRamaHelper().loadImagesFor(movies: &self.movies) { indexPathToRefresh in
                self.delegate?.update(state: .refreshListState(indexPath: indexPathToRefresh))
            }
            self.delegate?.update(state: .endRefreshState)
            
            self.mode == .showAllMovies ? self.switchModeToAllMoviesMode() : self.switchModeToSearchResultsMode()
        }
    }
}
