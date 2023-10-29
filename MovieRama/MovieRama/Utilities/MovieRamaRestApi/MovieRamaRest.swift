//
//  MovieRamaRest.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

class MovieRamaRest {
    let apiServices: MovieRamaRestProtocol?
    
    init(apiServices: MovieRamaRestProtocol?) {
        self.apiServices = apiServices
    }
    
    func getPopularMovies(forPage page: Int,
                          completionBlock: @escaping (GetMoviesResponse) -> Void,
                          errorBlock: @escaping (Error) -> Void) {
        self.apiServices?.getPopularMovies(forPage: page,
                                           completionBlock:
                                            completionBlock, errorBlock: errorBlock)
    }
    
    func searchMovies(searchTerm: String,
                      forPage page: Int,
                      completionBlock: @escaping (GetMoviesResponse) -> Void,
                      errorBlock: @escaping (Error) -> Void) {
        self.apiServices?.searchMovies(searchTerm: searchTerm,
                                       forPage: page,
                                       completionBlock: completionBlock,
                                       errorBlock: errorBlock)
    }
    
    func saveFavorite(for movie: Movie,
                      at indexPath: IndexPath,
                      completionBlock: @escaping () -> Void,
                      errorBlock: @escaping (Error) -> Void) {
        self.apiServices?.saveFavorite(for: movie,
                                       at: indexPath,
                                       completionBlock: completionBlock,
                                       errorBlock: errorBlock)
    }
    
    func getMovieDetails(for movie: Movie,
                         completionBlock: @escaping (Movie, [DetailFieldValue]) -> Void,
                         errorBlock: @escaping (Error) -> Void) {
        self.apiServices?.getMovieDetails(for: movie,
                                          completionBlock: completionBlock, errorBlock: errorBlock)
    }
    
    func getMovieReviews(for movie: Movie,
                         completionBlock: @escaping ([DetailFieldValue]) -> Void,
                         errorBlock: @escaping (Error) -> Void) {
        self.apiServices?.getMovieReviews(for: movie,
                                          completionBlock: completionBlock,
                                          errorBlock: errorBlock)
    }
    
    func getSimilarMovies(movie: Movie,
                          completionBlock: @escaping (DetailFieldValue) -> Void,
                          errorBlock: @escaping (Error) -> Void) {
        self.apiServices?.getSimilarMovies(movie: movie,
                                           completionBlock: completionBlock,
                                           errorBlock: errorBlock)
    }
}
