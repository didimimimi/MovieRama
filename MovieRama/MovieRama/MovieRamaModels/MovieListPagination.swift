//
//  MovieListPagination.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation

typealias MoviePage = [Movie]

class MovieListPagination {
    private var currentPage = 0
    private var moviesCurrentlyShown = 0
    private let moviesPerPage: Int
    
    private var pages = [MoviePage]()
    
    init(movies: [Movie], moviesPerPage: Int) {
        self.moviesPerPage = moviesPerPage
        
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
    
    func getNextPageData() -> (page: MoviePage, indexPathsToAppend: [IndexPath])? {
        if self.currentPage >= self.pages.count || pages.isEmpty {
            return nil
        } else {
            let page = self.pages[self.currentPage]
            
            let newAmountOfMoviesCurrentlyShown = self.moviesCurrentlyShown + page.count
            
            let indexPaths = Array(self.moviesCurrentlyShown..<newAmountOfMoviesCurrentlyShown)
                .map({ IndexPath(row: $0, section: 0) })
            
            self.moviesCurrentlyShown = newAmountOfMoviesCurrentlyShown
            self.currentPage += 1
            
            print("One more page added. Currently \(newAmountOfMoviesCurrentlyShown) movies visible.")
            return (page, indexPaths)
        }
    }
}
