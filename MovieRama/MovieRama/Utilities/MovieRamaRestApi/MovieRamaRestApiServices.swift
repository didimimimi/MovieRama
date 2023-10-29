//
//  MovieRamaRest.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 28/10/23.
//

import Foundation

class MovieRamaRestApiServices: MovieRamaRestProtocol {
    func getPopularMovies(forPage page: Int,
                          completionBlock: @escaping (GetMoviesResponse) -> Void,
                          errorBlock: @escaping (Error) -> Void) {
        self.handleGetMoviesCall(isSearchCall: false, searchTerm: "", forPage: page, completionBlock: completionBlock, errorBlock: errorBlock)
    }
    
    func searchMovies(searchTerm: String,
                      forPage page: Int,
                      completionBlock: @escaping (GetMoviesResponse) -> Void,
                      errorBlock: @escaping (Error) -> Void) {
        self.handleGetMoviesCall(isSearchCall: true, searchTerm: searchTerm, forPage: page, completionBlock: completionBlock, errorBlock: errorBlock)
    }
    
    private func handleGetMoviesCall(isSearchCall: Bool,
                                     searchTerm: String,
                                     forPage page: Int,
                                     completionBlock: @escaping (GetMoviesResponse) -> Void,
                                     errorBlock: @escaping (Error) -> Void) {
        let urlString = isSearchCall
        ? "https://api.themoviedb.org/3/search/movie?page=\(String(page))&query=\(searchTerm)&include_adult=false"
        : "https://api.themoviedb.org/3/movie/popular?page=\(String(page))&include_adult=false"
        
        self.makeApiCall(urlString: urlString,
                         completionBlock: { data in
            let domainModel = GetMoviesTransfromer().transform(apiModel: data)
            completionBlock(domainModel)
        }, errorBlock: { error in
            if let error = error {
                errorBlock(error)
            }
        })
    }
    
    func saveFavorite(for movie: Movie,
                      at indexPath: IndexPath,
                      completionBlock: @escaping () -> Void,
                      errorBlock: @escaping (Error) -> Void) {
        let percentageOfSuccess = 0.8
        let effortPercentage = Double.random(in: 0...1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            if effortPercentage < percentageOfSuccess {
                completionBlock()
            } else {
                errorBlock(MovieError.favoriteFailed(message: "Could not (un)favorite movie named:\n\(movie.title ?? "")"))
            }            
        }
    }
    
    func getMovieDetails(for movie: Movie,
                         completionBlock: @escaping (Movie) -> Void,
                         errorBlock: @escaping (Error) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movie.id ?? "")"
        
        self.makeApiCall(urlString: urlString,
                         completionBlock: { data in
            let domainModel = GetMovieDetailsTransfromer().transform(apiModel: data, onto: movie)
            completionBlock(domainModel)
        }, errorBlock: { error in
            if let error = error {
                errorBlock(error)
            }
        })
    }
    
    private func makeApiCall<T: Decodable>(urlString: String,
                                           completionBlock: @escaping (T) -> Void,
                                           errorBlock: @escaping (Error?) -> Void) {
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(MovieRamaConstants().API_KEY)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    errorBlock(error)
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let responseData = try decoder.decode(T.self, from: data)
                        
                        completionBlock(responseData)
                    }
                    catch {
                        errorBlock(error)
                    }
                }
            }
            
            task.resume()
        } else {
            print("Invalid URL")
        }
    }
}
