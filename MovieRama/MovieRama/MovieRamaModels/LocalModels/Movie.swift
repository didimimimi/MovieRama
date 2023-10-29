//
//  Movie.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation
import UIKit

class Movie: Equatable {
    var id: String?
    var title: String?
    var rating: Double?
    var date: String?
    var favorite: Bool?
    var genres: String?
    var overview: String?
    var runtime: String?
    var tagline: String?
    var similarMovies: [Movie] = []
    var reviews: [Review] = []
    
    var imageUrl: String?
    var image: UIImage?
    
    init() {}
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

class Review {
    var authorName: String?
    var comment: String?
}
