//
//  MovieListPagination.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation
import UIKit

class MovieListPagination {
    private var currentPage = 0
    private var moviesCurrentlyShown = 0
    private let moviesPerPage = MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE
    
    private var pages = [MoviePage]()
    
    
    init(movies: [Movie]) {
        var moviesList = movies
        
        self.paginate(movies: &moviesList)
    }
    
    private func paginate(movies: inout [Movie]) {
        while !movies.isEmpty {
            var page = MoviePage()
            
            for _ in 0..<self.moviesPerPage {
                if !movies.isEmpty {
                    page.append(movies.removeFirst())
                }
            }
            
            self.pages.append(page)
        }
    }
    
    func getNextPageData() -> PaginationResult? {
        if self.cannotLoadMorePages() {
            return nil
        } else {
            let page = self.pages[self.currentPage]
            
            let newAmountOfMoviesCurrentlyShown = self.moviesCurrentlyShown + page.count
            
            let indexPaths = Array(self.moviesCurrentlyShown..<newAmountOfMoviesCurrentlyShown)
                .map({ IndexPath(row: $0, section: 0) })
            
            self.moviesCurrentlyShown = newAmountOfMoviesCurrentlyShown
            self.currentPage += 1
            
            print("One more page added. Currently \(newAmountOfMoviesCurrentlyShown) movies visible.")
            return PaginationResult(page: page, indexPathsToAppend: indexPaths)
        }
    }
    
    func cannotLoadMorePages() -> Bool {
        hasNoPages() || hasReachedPageLimit()
    }
    
    func canLoadMorePages() -> Bool {
        !cannotLoadMorePages()
    }
    
    private func hasReachedPageLimit() -> Bool {
        self.currentPage >= self.pages.count
    }
    
    private func hasNoPages() -> Bool {
        pages.isEmpty
    }
    
    func appendNewMovies(movies: [Movie]) {
        var moviesList = movies
        var page = self.pages.last ?? []
        
        // fill last page before making new ones
        self.fit(movies: &moviesList, inPage: &page)
        
        self.paginate(movies: &moviesList)
    }
    
    private func fit(movies: inout [Movie], inPage page: inout MoviePage) {
        let pageCapacity = MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE - page.count
        
        for _ in 0..<pageCapacity {
            if !movies.isEmpty {
                page.append(movies.removeFirst())
            }
        }
    }
}
