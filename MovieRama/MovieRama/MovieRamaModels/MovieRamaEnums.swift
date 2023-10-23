//
//  MovieRamaEnums.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation

enum MovieRating: Int {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    
    init?(value: Double?) {
        guard let value = value else {
            return nil
        }
        self.init(rawValue: Int(value))
    }
    
    func getInStars() -> [StarEnum] {
        let emptyStarsAmount = MovieRamaConstants().MAX_STAR_RATING - self.rawValue
        
        let filledStars = Array(repeating: StarEnum.filled, count: self.rawValue)
        let emptyStars = Array(repeating: StarEnum.empty, count: emptyStarsAmount)
        
        return filledStars + emptyStars
    }
}

enum StarEnum: String {
    case filled = "star.fill"
    case empty = "star"
    
}

enum HeartEnum: String {
    case filled = "heart.fill"
    case empty = "heart"
    
    init(isFavorite: Bool) {
        self = isFavorite ? .filled : .empty
    }
}

enum MainScreenListMode {
    case showAllMovies
    case showSearchResults
}
