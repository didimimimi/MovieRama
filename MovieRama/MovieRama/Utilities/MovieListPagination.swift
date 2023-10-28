//
//  MovieListPagination.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation
import UIKit

protocol MovieListPaginationDelegate: AnyObject {
    func handleError(error: Error)
}

class MovieListPagination {
    private var currentApiPage = 0
    private var currentPage = -1
    private var moviesCurrentlyShown = 0
    private let moviesPerPage = MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE
    
    private var pages = [MoviePage]()
    
    weak var delegate: MovieListPaginationDelegate?
    
    init() {
        self.getNextBatchFromApi() {}
    }
    
    init(delegate: MovieListPaginationDelegate) {
        self.delegate = delegate
        
        self.getNextBatchFromApi() {}
    }
    
    private func getNextBatchFromApi(completion: @escaping () -> Void) {
        self.currentApiPage += 1
        
        MovieRamaRest().getPopularMovies(forPage: self.currentApiPage,
                                         completionBlock: { response in
            var moviesList = response.movies
            
            while !moviesList.isEmpty {
                var page = MoviePage()
                
                for _ in 0..<self.moviesPerPage { // populate movies in per page
                    if !moviesList.isEmpty {
                        page.append(moviesList.removeFirst())
                    }
                }
                
                self.pages.append(page)
            }
            
            completion()
        }, errorBlock: { error in
            self.delegate?.handleError(error: error)
        })
    }
    
    func getNextPageData(completion: @escaping (PaginationResult?) -> Void) {
        if self.currentApiPage < MovieRamaConstants().MAX_API_PAGES {
            if self.currentPage >= self.pages.count - 1 {
//                var paginationResult = PaginationResult()
//
//                self.getNextBatchFromApi() {
//                    paginationResult = self.collectPageData()
//                }
//
//                return paginationResult

                self.getNextBatchFromApi {
                    completion(self.collectPageData())
                }
            } else {
                completion(self.collectPageData())
            }
        } else {
            completion(nil)
        }
    }
    
    private func collectPageData() -> PaginationResult {
        self.currentPage += 1
        
        let page = self.pages[self.currentPage]
        
        let newAmountOfMoviesCurrentlyShown = self.moviesCurrentlyShown + page.count
        
        let indexPaths = Array(self.moviesCurrentlyShown..<newAmountOfMoviesCurrentlyShown)
            .map({ IndexPath(row: $0, section: 0) })
        
        self.moviesCurrentlyShown = newAmountOfMoviesCurrentlyShown
        
        print("One more page added. Currently \(newAmountOfMoviesCurrentlyShown) movies visible.")
        return PaginationResult(page: page, indexPathsToAppend: indexPaths)
    }
    
    private func needsToLoadMorePages() -> Bool {
        let hasNoPages = pages.isEmpty
        let hasReachedPageLimit = self.currentPage >= self.pages.count
        let canLoadMoreApiPages = self.currentApiPage < MovieRamaConstants().MAX_API_PAGES
        
        return canLoadMoreApiPages && (hasNoPages || hasReachedPageLimit)
    }
}
