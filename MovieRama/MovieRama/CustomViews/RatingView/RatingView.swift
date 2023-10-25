//
//  RatingView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation
import UIKit

@IBDesignable
class RatingView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    static let viewId = "RatingView"
    
    private var filledStarImage: UIImage?
    private var emptyStarImage: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp(forNib: RatingView.viewId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp(forNib: RatingView.viewId)
    }
    
    func setRating(stars: MovieRating) {
        self.ratingStackView.removeAllArrangedSubviews()
        
        let starImages = stars.getInStars()
        
        starImages.forEach({ starImage in
            self.ratingStackView.addArrangedSubview(StarView(star: starImage))
        })
    }
}
