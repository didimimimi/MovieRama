//
//  MovieRamaPaginationModel.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 28/10/23.
//

import Foundation

typealias MoviePage = [Movie]

class PopularMoviesResponse {
    var currentPage = 0
    var movies = [Movie]()
    
    init() {}
}
