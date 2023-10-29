//
//  ApiGetMoviesTransfromer.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 28/10/23.
//

import Foundation
import UIKit

class GetMoviesTransfromer {
    func transform(apiModel: ApiGetMoviesResponse) -> GetMoviesResponse {
        let domainModel = GetMoviesResponse()
        domainModel.currentPage = apiModel.page ?? 0
        
        if let apiMovies = apiModel.apiMovies {
            domainModel.movies = apiMovies.map({ self.transformMovie(apiModel: $0) })
        }
        
        return domainModel
    }
    
    private func transformMovie(apiModel: ApiMovie) -> Movie {
        var movie = Movie()
        
        movie.id = String(apiModel.id ?? 0)
        
        if let title = apiModel.title, let originalTitle = apiModel.original_title, title != originalTitle {
            movie.title = "\(title) (\(originalTitle))"
        } else {
            movie.title = apiModel.title
        }
        
        movie.rating = round((apiModel.vote_average ?? 0) / 2)
        movie.date = DateUtilities().formatDate(date: apiModel.release_date)
        movie.imageUrl = MovieRamaConstants().IMAGE_PATH_PREFIX + (apiModel.backdrop_path ?? "")
        
        MovieRamaHelper().loadImageFrom(urlString: movie.imageUrl) { image in
            if let image = image {
                movie.image = image                
            }
        }
        
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie)
                
        return movie
    }    
}
