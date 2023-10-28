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
    private var hasAlradyRemovedLoadingCell = false
    
    private var currentApiPageForMovies = 1
    private var currentApiPageForSearchResults = 1

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
    
    func scrolledToBottom() {
        var canLoadMoreLocalPages: Bool
        var canLoadMoreApiPages: Bool
        
        switch self.mode {
        case .showAllMovies:
            canLoadMoreLocalPages = (self.pagination?.canLoadMorePages() == true)
            canLoadMoreApiPages = self.currentApiPageForMovies < MovieRamaConstants().MAX_API_PAGES
        case .showSearchResults:
            canLoadMoreLocalPages = (self.searchMoviesPagination?.canLoadMorePages() == true)
            canLoadMoreApiPages = self.currentApiPageForSearchResults < MovieRamaConstants().MAX_API_PAGES
        }
        
        if canLoadMoreLocalPages {
            if !self.isLoadingMoreMovies {
                self.delegate?.update(state: .addLoadingCellState)
                self.loadMoreMovies()
            }
        } else {
            if canLoadMoreApiPages {
                if !self.isLoadingMoreMovies {
                    self.delegate?.update(state: .addLoadingCellState)
                    self.currentApiPageForMovies += 1
                    self.getApiPages(specifiedPage: self.currentApiPageForMovies)
                    self.loadMoreMovies()
                }
            } else {
                if !self.hasAlradyRemovedLoadingCell {
                    self.hasAlradyRemovedLoadingCell = true
                    self.delegate?.update(state: .removeLoadingCellState)
                }
            }
        }
    }
    
    private func loadMoreMovies() {
        self.isLoadingMoreMovies = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoadingMoreMovies = false
            
            let paginationResult = self.getPaginationNextPage()
            
            guard let paginationResult = paginationResult else {
                return
            }
            
            let moviesForScreen = paginationResult.page
            let newIndexPaths = paginationResult.indexPathsToAppend
            
            self.delegate?.update(state: .appendToListState(movies: moviesForScreen, indexPaths: newIndexPaths))
        }
    }
    
    private func getPaginationNextPage() -> PaginationResult? {
        let paginationResult: PaginationResult?

        switch self.mode {
        case .showAllMovies:
            paginationResult = self.pagination?.getNextPageData()
        case.showSearchResults:
            paginationResult = self.searchMoviesPagination?.getNextPageData()
        }
        
        return paginationResult
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
        
        let moviesForScreen = selectedPagination?.getNextPageData()?.page ?? []
        
        self.delegate?.update(state: .emptyListState(hide: !moviesForScreen.isEmpty))
        self.delegate?.update(state: .createListState(movies: moviesForScreen))
    }
    
    private func makePagination() -> MovieListPagination? {
        let selectedPagination: MovieListPagination?

        switch self.mode {
        case .showAllMovies:
            self.pagination = MovieListPagination(movies: self.movies)
            selectedPagination = self.pagination
        case .showSearchResults:
            self.searchMoviesPagination = MovieListPagination(movies: self.searchResults)
            selectedPagination = self.searchMoviesPagination
        }
        
        return selectedPagination
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.getApiPages(specifiedPage: 1)
            
//            MovieRamaHelper().loadImagesFor(movies: &self.movies) { indexPathToRefresh in
//                self.delegate?.update(state: .refreshListState(indexPath: indexPathToRefresh))
//            }
            self.delegate?.update(state: .endRefreshState)
            
            self.mode == .showAllMovies ? self.switchModeToAllMoviesMode() : self.switchModeToSearchResultsMode()
        }
    }
    
    private func getApiPages(specifiedPage: Int) {
        MovieRamaRest().getPopularMovies(forPage: specifiedPage, completionBlock: { response in
            if specifiedPage == 1 {
                self.movies = response.movies
            } else {
                self.movies.append(contentsOf: response.movies)
                self.pagination?.appendNewMovies(movies: response.movies)
            }
        }, errorBlock: { error in
            self.delegate?.update(state: .errorState(error: error))
        })
    }
}
