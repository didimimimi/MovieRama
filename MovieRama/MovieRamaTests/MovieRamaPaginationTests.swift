//
//  MovieRamaPaginationTests.swift
//  MovieRamaTests
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import XCTest
@testable import MovieRama

final class MovieRamaPaginationTests: XCTestCase {

    var mockRest: MovieRamaRest?
    
    override func setUpWithError() throws {
        MovieRamaSingleton.sharedInstance.restClient = MovieRamaRestMockServices()
        mockRest = MovieRamaRest(apiServices: MovieRamaSingleton.sharedInstance.restClient)
    }

    // Getting one page from a pagination should return the correct amount of movies, the correct pages and correct indexPaths of the movies
    func test_initialPagination() throws {
        let movies = self.generateMovies(amount: 30)
        
        let pagination = MovieListPagination(movies: movies)
        let paginationResult = try XCTUnwrap(pagination.getNextPageData())
        
        XCTAssertEqual(paginationResult.page.count, MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE, "Incorrect amount of movies in page")
        
        let expectedPage = Array(movies[0..<MovieRamaConstants().PAGINATION_NUMBER_OF_ITEMS_PER_PAGE])
        XCTAssertEqual(paginationResult.page, expectedPage, "Incorrect page")
        
        var indexPaths: [IndexPath] = []
        
        for row in 0..<10 {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
        }
        
        XCTAssertEqual(paginationResult.indexPathsToAppend, indexPaths, "Incorrect index paths of movies in page")
    }
    
    func generateMovies(amount: Int) -> [Movie] {
        var movies = [Movie]()
        
        for index in 0..<amount {
            let movie = Movie()
            movie.id = String(index)
            movies.append(movie)
        }
        
        return movies
    }
    
    private func makePagination(amountOfMovies: Int) -> MovieListPagination {
        let movies = self.generateMovies(amount: 5)
        
        return MovieListPagination(movies: movies)
    }
    
    // Getting a page after the last should be nil
    func test_fullPagination() {
        let pagination = makePagination(amountOfMovies: 5)
        
        _ = pagination.getNextPageData()
        
        let paginationResult = pagination.getNextPageData()
        
        XCTAssertNil(paginationResult, "Pagination is not full")
    }
    
    // Adding more movies should increse the capacity
    func test_addMoreMoviesToThePagination() {
        let movies = self.generateMovies(amount: 5)
        let pagination = MovieListPagination(movies: movies)
        
        self.mockRest?.getPopularMovies(forPage: 1,
                                        completionBlock: { response in
            pagination.appendNewMovies(movies: response.movies)
            
            if let paginationResult1 =  pagination.getNextPageData(), let paginationResult2 =  pagination.getNextPageData() {
                XCTAssertEqual(paginationResult1.page.count, 10,
                               "Pagination first page should have 10 elements in a 15 pagination of 10 movies per page")
                
                XCTAssertEqual(paginationResult2.page.count, 5,
                               "Pagination second page should have 5 elements in a 15 pagination of 10 movies per page")
            }
            
        }, errorBlock: { _ in })
    }
    
    
}
