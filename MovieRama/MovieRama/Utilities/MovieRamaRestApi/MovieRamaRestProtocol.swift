//
//  MovieRamaRestProtocol.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

protocol MovieRamaRestProtocol: AnyObject {
    func getPopularMovies(forPage page: Int,
                          completionBlock: @escaping (GetMoviesResponse) -> Void,
                          errorBlock: @escaping (Error) -> Void)
    
    func searchMovies(searchTerm: String,
                      forPage page: Int,
                      completionBlock: @escaping (GetMoviesResponse) -> Void,
                      errorBlock: @escaping (Error) -> Void)
    
    func saveFavorite(for movie: Movie,
                      at indexPath: IndexPath,
                      completionBlock: @escaping () -> Void,
                      errorBlock: @escaping (Error) -> Void)
    
    func getMovieDetails(for movie: Movie,
                         completionBlock: @escaping (Movie, [DetailFieldValue]) -> Void,
                         errorBlock: @escaping (Error) -> Void)
    
    func getMovieReviews(for movie: Movie,
                         completionBlock: @escaping ([DetailFieldValue]) -> Void,
                         errorBlock: @escaping (Error) -> Void)
    
    func getSimilarMovies(movie: Movie,
                          completionBlock: @escaping (DetailFieldValue) -> Void,
                          errorBlock: @escaping (Error) -> Void)
}
