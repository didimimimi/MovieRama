//
//  PaginationResult.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 28/10/23.
//

import Foundation

class PaginationResult {
    var page = MoviePage()
    var indexPathsToAppend = [IndexPath]()
    
    init() {}
    
    init(page: MoviePage, indexPathsToAppend: [IndexPath]) {
        self.page = page
        self.indexPathsToAppend = indexPathsToAppend
    }
}
