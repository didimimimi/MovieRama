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
    
    func setUpMockMovies() -> [Movie] {
        var movies = [Movie]()
        
        var movie1 = Movie()
        movie1.id = "movie_1"
        movie1.title = "Scarface"
        movie1.rating = 4
        movie1.date = "Jul 1 2022"
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie1)
        movie1.imageUrl = "https://a.ltrbxd.com/resized/sm/upload/xs/d9/wj/nt/scarface-1200-1200-675-675-crop-000000.jpg?v=3e9a08f31f"
        
        var movie2 = Movie()
        movie2.id = "movie_2"
        movie2.title = "Avengers"
        movie2.rating = 2
        movie2.date = "Jul 7 2022"
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie2)
        movie2.imageUrl = "https://cdn.vox-cdn.com/thumbor/q1VhYtuVNtHtWRCb2icgjPzX3Sw=/0x0:1920x1005/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/15969338/surprise_marvel_releases_a_new_full_trailer_and_poster_for_avengers_endgame_social.jpg"
        
        var movie3 = Movie()
        movie3.id = "movie_3"
        movie3.title = "Mr Bean"
        movie3.rating = 5
        movie3.date = "Dec 27 2000"
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie3)
        movie3.imageUrl = "https://occ-0-2794-2219.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABWY9s8-7p1oide16Hv52wGnwTG3oEiIvX-6t5jX5oyvPlaFVGPjjuy_nCtmHZsNMaUTqJbxsjBma3hAQ1d81Nz6nCD0yW9g0QOnt.jpg?r=d11"
        
        movies.append(movie1)
        movies.append(movie2)
        movies.append(movie3)

        return movies
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
