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
        self.setUpNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpNib()
    }
    
    private func setUpNib() {
        let nib = UINib(nibName: RatingView.viewId, bundle: nil)
        
        guard let view = nib.instantiate(withOwner: self).first as? UIView else {
            fatalError("Cannot load nib")
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
    }
    
    func setRating(stars: MovieRating) {
        self.ratingStackView.removeAllArrangedSubviews()
        
        let starImages = stars.getInStars()
        
        starImages.forEach({ starImage in
            self.ratingStackView.addArrangedSubview(StarView(star: starImage))
        })
    }
}
