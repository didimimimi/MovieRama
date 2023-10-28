//
//  MovieRamaRest.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 28/10/23.
//

import Foundation

class MovieRamaRest {
    let imagePath = "https://image.tmdb.org/t/p/original/"
    
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGM0MGEyYmRkNzFhYWRjN2I4NzUzN2Y1MzQ2MGU3OSIsInN1YiI6IjY1MzkyMzlkOWMyNGZjMDE0MmIzMWU5NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6XA7eyJSx_2kLNB_GAEnXPrweeyUBupLktnZWH6DLEI"
    
    func getPopularMovies(forPage page: Int,
                          completionBlock: @escaping (PopularMoviesResponse) -> Void,
                          errorBlock: @escaping (Error) -> Void) {
        self.handleCall(isSearchCall: false, searchTerm: "", forPage: page, completionBlock: completionBlock, errorBlock: errorBlock)
    }
    
    func searchMovies(searchTerm: String,
                      forPage page: Int,
                      completionBlock: @escaping (PopularMoviesResponse) -> Void,
                      errorBlock: @escaping (Error) -> Void) {
        self.handleCall(isSearchCall: true, searchTerm: searchTerm, forPage: page, completionBlock: completionBlock, errorBlock: errorBlock)
    }
    
    private func handleCall(isSearchCall: Bool,
                            searchTerm: String,
                            forPage page: Int,
                            completionBlock: @escaping (PopularMoviesResponse) -> Void,
                            errorBlock: @escaping (Error) -> Void) {
        let urlString = isSearchCall
        ? "https://api.themoviedb.org/3/search/movie?page=\(String(page))&query=\(searchTerm)"
        : "https://api.themoviedb.org/3/movie/popular?page=\(String(page))"
        
        self.makeApiCall(urlString: urlString,
                         completionBlock: { data in
            let paginationModel = ApiPopularMoviesTransfromer().transform(apiModel: data)
            completionBlock(paginationModel)
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
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
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
