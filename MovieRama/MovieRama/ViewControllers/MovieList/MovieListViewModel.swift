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
    
    private var searchText = ""

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
        self.searchText = text
        
        if self.searchText.isEmpty {
            self.switchModeToAllMoviesMode()
        } else {
            self.performSearch(text: self.searchText)
        }
    }
    
    private func performSearch(text: String) {
        self.getApiPagesForSearch(searchTerm: text, specifiedPage: 1) {
            self.switchModeToSearchResultsMode()
        }
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
            loadMoreLocalPages()
        } else {
            if canLoadMoreApiPages {
                loadMoreApiPages()
            } else {
                removeLoadingIfReachedAbsoluteBottom()
            }
        }
    }
    
    private func loadMoreLocalPages() {
        if !self.isLoadingMoreMovies {
            self.delegate?.update(state: .addLoadingCellState)
            self.loadMoreMovies()
        }
    }
    
    private func loadMoreApiPages() {
        if !self.isLoadingMoreMovies {
            self.delegate?.update(state: .addLoadingCellState)
            switch self.mode {
            case .showAllMovies:
                self.currentApiPageForMovies += 1
                
                self.getApiPages(specifiedPage: self.currentApiPageForMovies) {
                    self.loadMoreMovies()
                }
            case .showSearchResults:
                self.currentApiPageForSearchResults += 1
                
                self.getApiPagesForSearch(searchTerm: self.searchText, specifiedPage: self.currentApiPageForSearchResults) {
                    self.loadMoreMovies()
                }
            }
        }
    }
    
    private func removeLoadingIfReachedAbsoluteBottom() {
        if !self.hasAlradyRemovedLoadingCell {
            self.hasAlradyRemovedLoadingCell = true
            self.delegate?.update(state: .removeLoadingCellState)
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
            switch self.mode {
            case .showAllMovies:
                self.getApiPages(specifiedPage: 1) {
                    self.delegate?.update(state: .endRefreshState)
                    self.switchModeToAllMoviesMode()
                }
            case .showSearchResults:
                self.getApiPagesForSearch(searchTerm: self.searchText, specifiedPage: 1) {
                    self.delegate?.update(state: .endRefreshState)
                    self.switchModeToSearchResultsMode()
                }
            }
        }
    }
    
    private func getApiPages(specifiedPage: Int,
                             completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            MovieRamaRest().getPopularMovies(forPage: specifiedPage, completionBlock: { response in
                if specifiedPage == 1 {
                    self.movies = response.movies
                } else {
                    self.movies.append(contentsOf: response.movies)
                    self.pagination?.appendNewMovies(movies: response.movies)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            }, errorBlock: { error in
                self.delegate?.update(state: .errorState(error: error))
            })
        }
    }
    
    private func getApiPagesForSearch(searchTerm: String,
                                      specifiedPage: Int,
                                      completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            MovieRamaRest().searchMovies(searchTerm: searchTerm, forPage: specifiedPage, completionBlock: { response in
                if specifiedPage == 1 {
                    self.searchResults = response.movies
                } else {
                    self.searchResults.append(contentsOf: response.movies)
                    self.searchMoviesPagination?.appendNewMovies(movies: response.movies)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            }, errorBlock: { error in
                self.delegate?.update(state: .errorState(error: error))
            })
        }
    }
}
