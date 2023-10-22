//
//  Movie.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation

class Movie {
    var id: String?
    var title: String?
    var rating: Double?
    var date: String?
    var image: String?
    var favoriteInfo: FavoriteInfo?
    var genres: [String] = []
    var description: String?
    var director: String?
    var cast: String?
    var similarMovies: [Movie] = []
    var reviews: [Review] = []
    
    init() {}
    
    func loadFavoriteInfoFromDevice() {
        let defaults = UserDefaults.standard

        if let movieId = self.id,
           let savedFavoriteInfo = defaults.object(forKey: MovieRamaConstants().FAVORITE_MOVIE_KEY + movieId) as? Data {
            let decoder = JSONDecoder()
            if let loadedFavoriteInfo = try? decoder.decode(FavoriteInfo.self, from: savedFavoriteInfo) {
                self.favoriteInfo = loadedFavoriteInfo
            }
        }
    }
}

class Review {
    var authorName: String?
    var comment: String?
}

class FavoriteInfo: Codable {
    var movieId: String?
    var favorite: Bool?
    
    func saveFavoriteInfoToDevice() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self), let movieId = self.movieId {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: MovieRamaConstants().FAVORITE_MOVIE_KEY + movieId)
        }
    }
}


