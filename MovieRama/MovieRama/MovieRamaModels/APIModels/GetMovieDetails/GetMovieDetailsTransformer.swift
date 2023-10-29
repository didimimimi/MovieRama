//
//  GetMovieDetailsTransformer.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

class GetMovieDetailsTransfromer {
    func transform(apiModel: ApiGetMovieDetailsResponse, onto movie: Movie) -> Movie {
        var domainModel = movie
        
        if let genres = apiModel.genres {
            domainModel.genres = genres.map({ $0.name ?? "" }).joined(separator: ", ")
        }
        
        movie.overview = apiModel.overview
        
        if let runtime = apiModel.runtime {
            let hours = runtime / 60
            let minutes = runtime % 60
            let inHours = "\(hours) hours and \(minutes) minutes"
            domainModel.runtime = "\(inHours) (\(apiModel.runtime ?? 0) minutes)"
        }
        
        domainModel.tagline = apiModel.tagline
        
        return domainModel
    }    
}
