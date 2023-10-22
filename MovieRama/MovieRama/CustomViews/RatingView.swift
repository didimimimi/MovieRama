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
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        self.setUpNib()
        self.setUpStarImages()
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
    
    private func setUpStarImages() {
        self.filledStarImage = UIImage(systemName: "star.fill")
        self.emptyStarImage = UIImage(systemName: "star")
        
        self.filledStarImage?.withTintColor(MovieRamaConstants().APP_COLOR, renderingMode: .alwaysOriginal)
        self.emptyStarImage?.withTintColor(MovieRamaConstants().APP_COLOR, renderingMode: .alwaysOriginal)
    }
    
    func setRating(stars: MovieRating) {
        let filledStars = stars.rawValue
        let blankStars = MovieRamaConstants().MAX_STAR_RATING - filledStars
        
        if filledStars != 0 {
            for _ in 1...filledStars {
                self.ratingStackView.addArrangedSubview(UIImageView(image: self.filledStarImage))
            }
        }
        
        if blankStars != 0 {
            for _ in 1...blankStars {
                self.ratingStackView.addArrangedSubview(UIImageView(image: self.emptyStarImage))
            }
        }
    }
}
