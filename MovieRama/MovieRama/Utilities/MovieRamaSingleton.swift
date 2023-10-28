//
//  MovieRamaSingleton.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 25/10/23.
//

import Foundation

class MovieRamaSingleton {
    var pagination: MovieListPagination?
    
    private init() {}
    
    static let sharedInstance = MovieRamaSingleton()
}
