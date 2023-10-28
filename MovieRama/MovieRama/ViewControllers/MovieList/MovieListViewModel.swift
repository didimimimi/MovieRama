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
    
    private var isLoadingMoreMovies = false
    
    private var hasLoadedPaginationFromSplashScreen = false
    
    init(delegate: MovieListViewModelDelegate) {
        self.delegate = delegate
        
        self.loadMoviesFromSplashScreen()
    }
    
    init() {}
    
    private func loadMoviesFromSplashScreen() {
        self.pagination = MovieRamaSingleton.sharedInstance.pagination
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
    
    func scrolledToBottom() {
        if self.isLoadingMoreMovies {
            return
        }
        
        self.delegate?.update(state: .addLoadingCellState)
        self.loadMoreMovies()
    }
    
    private func loadMoreMovies() {
        self.isLoadingMoreMovies = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoadingMoreMovies = false
            
            DispatchQueue.global().async {
                var paginationResult: PaginationResult?
                
                self.getPaginationNextPage() { result in
                    paginationResult = result
                    
                    guard let paginationResult = paginationResult else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let moviesForScreen = paginationResult.page
                        let newIndexPaths = paginationResult.indexPathsToAppend
                        
                        self.delegate?.update(state: .appendToListState(movies: moviesForScreen, indexPaths: newIndexPaths))
                    }
                }
            }
        }
    }
    
    private func getPaginationNextPage(completion: @escaping (PaginationResult?) -> Void) {
        var paginationResult: PaginationResult?

        switch self.mode {
        case .showAllMovies:
            self.pagination?.getNextPageData() { result in
                paginationResult = result
                completion(paginationResult)
            }
        case.showSearchResults:
            self.searchMoviesPagination?.getNextPageData() { result in
                paginationResult = result
                completion(paginationResult)
            }
        }
    }
    
    private func switchModeToAllMoviesMode() {
        self.switchModeAndGetNextPage(to: .showAllMovies)
    }
    
    private func switchModeToSearchResultsMode() {
        self.switchModeAndGetNextPage(to: .showSearchResults)
    }
    
    private func switchModeAndGetNextPage(to mode: MainScreenListMode) {
        self.mode = mode
        let selectedPagination = self.makePagination()
        
        var moviesForScreen = [Movie]()
        
        selectedPagination?.getNextPageData() { result in
            if let page = result?.page {
                moviesForScreen = page
            }
        }
        
        self.delegate?.update(state: .emptyListState(hide: !moviesForScreen.isEmpty))
        self.delegate?.update(state: .createListState(movies: moviesForScreen))
    }
    
    private func makePagination() -> MovieListPagination? {
        let selectedPagination: MovieListPagination?

        switch self.mode {
        case .showAllMovies:
            if self.hasLoadedPaginationFromSplashScreen {
                self.pagination = MovieListPagination(delegate: self)
            } else {
                self.hasLoadedPaginationFromSplashScreen = true
            }
            selectedPagination = self.pagination
        case .showSearchResults:
            self.searchMoviesPagination = MovieListPagination(delegate: self)
            selectedPagination = self.searchMoviesPagination
        }
        
        return selectedPagination
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // TODO: API Call for movies and setting them to movies, self.movies = response
//            self.movies = MovieRamaHelper().setUpMockMovies()
//
//            MovieRamaHelper().loadImagesFor(movies: &self.movies) { indexPathToRefresh in
//                self.delegate?.update(state: .refreshListState(indexPath: indexPathToRefresh))
//            }
            
//            self.pagination = se
            self.delegate?.update(state: .endRefreshState)
            
            self.mode == .showAllMovies ? self.switchModeToAllMoviesMode() : self.switchModeToSearchResultsMode()
        }
    }
}
