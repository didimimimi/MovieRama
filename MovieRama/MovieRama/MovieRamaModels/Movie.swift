//
//  Movie.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation

class Movie: Equatable {
    var id: String?
    var title: String?
    var rating: Double?
    var date: String?
    var image: String?
    var favorite: Bool?
    var genres: [String] = []
    var description: String?
    var director: String?
    var cast: String?
    var similarMovies: [Movie] = []
    var reviews: [Review] = []
    
    init() {}
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

class Review {
    var authorName: String?
    var comment: String?
}
