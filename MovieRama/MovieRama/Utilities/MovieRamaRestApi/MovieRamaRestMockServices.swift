//
//  MovieRamaRestMockServices.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

class MovieRamaRestMockServices: MovieRamaRestProtocol {
    var amountOfMoviesToReturnForPopularMovies = 10
    
    func getPopularMovies(forPage page: Int, completionBlock: @escaping (GetMoviesResponse) -> Void, errorBlock: @escaping (Error) -> Void) {
        performFakeCallForObtainingTheMovies(completionBlock)
    }
    
    func searchMovies(searchTerm: String, forPage page: Int, completionBlock: @escaping (GetMoviesResponse) -> Void, errorBlock: @escaping (Error) -> Void) {
        performFakeCallForObtainingTheMovies(completionBlock)
    }
    
    func saveFavorite(for movie: Movie, at indexPath: IndexPath, completionBlock: @escaping () -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    func getMovieDetails(for movie: Movie, completionBlock: @escaping (Movie, [DetailFieldValue]) -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    func getMovieReviews(for movie: Movie, completionBlock: @escaping ([DetailFieldValue]) -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    func getSimilarMovies(movie: Movie, completionBlock: @escaping (DetailFieldValue) -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    private func performFakeCallForObtainingTheMovies(_ completionBlock: (GetMoviesResponse) -> Void) {
        let response = GetMoviesResponse()
        response.currentPage = 1
        
        response.movies = Array(repeating: Movie(), count: amountOfMoviesToReturnForPopularMovies)
        for (index, movie) in response.movies.enumerated() {
            movie.id = String(index)
        }
        
        completionBlock(response)
    }
}
