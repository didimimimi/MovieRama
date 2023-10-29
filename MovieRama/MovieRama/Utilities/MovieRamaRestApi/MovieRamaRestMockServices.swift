//
//  MovieRamaRestMockServices.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

class MovieRamaRestMockServices: MovieRamaRestProtocol {
    func getPopularMovies(forPage page: Int, completionBlock: @escaping (GetMoviesResponse) -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    func searchMovies(searchTerm: String, forPage page: Int, completionBlock: @escaping (GetMoviesResponse) -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    func saveFavorite(for movie: Movie, at indexPath: IndexPath, completionBlock: @escaping () -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
    
    func getMovieDetails(for movie: Movie, completionBlock: @escaping (Movie) -> Void, errorBlock: @escaping (Error) -> Void) {
        
    }
}
