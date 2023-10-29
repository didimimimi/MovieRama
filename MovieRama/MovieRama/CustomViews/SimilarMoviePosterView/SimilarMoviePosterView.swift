//
//  SimilarMoviePosterView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation
import UIKit

@IBDesignable
class SimilarMoviePosterView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    static let viewId = "SimilarMoviePosterView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp(forNib: SimilarMoviePosterView.viewId) {
            self.setUpActivityIndicator()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp(forNib: SimilarMoviePosterView.viewId) {
            self.setUpActivityIndicator()
        }
    }
    
    private func setUpActivityIndicator() {
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = MovieRamaConstants().INDICATOR_COLOR
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.containerView.layer.masksToBounds = false
            self.containerView.layer.cornerRadius = 4
            
            self.containerView.layer.shadowColor = UIColor.black.cgColor
            self.containerView.layer.shadowOpacity = 0.5
            self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.containerView.layer.shadowRadius = 4
    
            self.posterImageView.layer.masksToBounds = true
            self.posterImageView.layer.cornerRadius = 4
        }
    }
    
    func update(withMovie movie: Movie) {
        if let posterImage = movie.posterImage {
            self.posterImageView.image = posterImage
        } else {
            self.activityIndicator.startAnimating()
            
            MovieRamaHelper().loadImageFrom(urlString: movie.posterImageUrl) { image in
                self.activityIndicator.stopAnimating()
                self.posterImageView.image = image
            }
        }
    }
}
