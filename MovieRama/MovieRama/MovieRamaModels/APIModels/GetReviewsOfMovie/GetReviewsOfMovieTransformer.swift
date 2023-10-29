//
//  GetReviewsOfMovieTransformer.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

class GetReviewsOfMovieTransformer {
    func transform(apiModel: ApiGetReviewsOfMovieResponse) -> [DetailFieldValue] {
        var domainReviews = [DetailFieldValue]()
        
        if var apiReviews = apiModel.results, !apiReviews.isEmpty {
            while domainReviews.count != 2 { // only do this max twice
                if !apiReviews.isEmpty {
                    let apiReview = apiReviews.removeFirst() // get next review and add it to our model
                    
                    var domainReview = self.transform(apiModel: apiReview)
                    
                    if !domainReviews.isEmpty { // remove the title from the second view so that it doesn't say "REVIEWS" again
                        domainReview.title = nil
                    }
                    
                    domainReviews.append(domainReview)
                } else {
                    break
                }
            }
        }
        
        return domainReviews
    }
    
    private func transform(apiModel: ApiReview) -> DetailFieldValue {
        return DetailFieldValue(title: .reviews,
                                information: "\(apiModel.author ?? "") (\(apiModel.author_details?.username ?? ""))",
                                description: apiModel.content)
    }
}
