//
//  MovieRamaHelper.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation

class MovieRamaHelper {
    func saveFavoriteInfoToDevice(ofMovie movie: Movie) {
        guard let id = movie.id else {
            return
        }
        let favorite = movie.favorite ?? false

        UserDefaults.standard.set(favorite, forKey: id)
    }
    
    func loadFavoriteInfoFromDevice(forMovie movie: inout Movie) {
        guard let id = movie.id else {
            return
        }

        movie.favorite = UserDefaults.standard.bool(forKey: id)
    }
}
