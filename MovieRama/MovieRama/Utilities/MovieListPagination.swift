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
        
        while !moviesList.isEmpty {
            var page = MoviePage()
            
            for _ in 0..<self.moviesPerPage {
                if !moviesList.isEmpty {
                    page.append(moviesList.removeFirst())
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
}
