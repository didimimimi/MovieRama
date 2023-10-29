//
//  SimilarMoviePostersListView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation
import UIKit

@IBDesignable
class SimilarMoviePostersListView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var postersStackView: UIStackView!
    
    static let viewId = "SimilarMoviePostersListView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp(forNib: SimilarMoviePostersListView.viewId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp(forNib: SimilarMoviePostersListView.viewId)
    }
    
    func configure(value: DetailFieldValue) {
        self.setValuesForPosters(from: value.similarMovies)
        
        self.layoutIfNeeded()
    }
    
    private func setValuesForPosters(from movies: [Movie]) {
        if movies.isEmpty {
            self.postersStackView.isHidden = true
        } else {
            self.postersStackView.removeAllArrangedSubviews()
            
            self.postersStackView.isHidden = false
            
            movies.forEach({
                let posterView = SimilarMoviePosterView()
                posterView.update(withMovie: $0)
                
                self.postersStackView.addArrangedSubview(posterView)
            })
        }
    }
}
