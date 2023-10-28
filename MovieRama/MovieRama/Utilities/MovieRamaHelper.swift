//
//  MovieRamaHelper.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation
import UIKit

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
    
    func loadImageFrom(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func loadImagesFor(movies: inout [Movie], completion: @escaping (IndexPath) -> Void) {
        
        for (index, movie) in movies.enumerated() {
            MovieRamaHelper().loadImageFrom(urlString: movie.imageUrl) { responseImage in
                movie.image = responseImage
                
                let indexPath = IndexPath(row: index, section: 0)
                completion(indexPath)
            }
        }
    }
}
