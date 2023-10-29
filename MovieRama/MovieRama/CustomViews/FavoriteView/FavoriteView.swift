//
//  FavoriteView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation
import UIKit

protocol FavoriteViewDelegate: AnyObject {
    func onfavoriteTappedSucceeded(indexPath: IndexPath)
    func onfavoriteTappedError(error: Error)
}

@IBDesignable
class FavoriteView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var setFavoriteActivityIndicator: UIActivityIndicatorView!
    
    private var movie = Movie()
    private var indexPath = IndexPath()
    private var isFavorite = false
    
    private weak var delegate: FavoriteViewDelegate?
    
    static let viewId = "FavoriteView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp(forNib: FavoriteView.viewId) {
            self.setUpView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp(forNib: FavoriteView.viewId) {
            self.setUpView()
        }
    }
    
    private func setUpView() {
        self.heartImageView.image = UIImage(systemName: "heart")
        self.heartImageView.tintColor = .red.withAlphaComponent(0.8)
            
        self.setFavoriteActivityIndicator.isHidden = true
        self.setFavoriteActivityIndicator.hidesWhenStopped = true
        self.setFavoriteActivityIndicator.color = MovieRamaConstants().INDICATOR_COLOR
    }
    
    func updateFavoriteView(movie: Movie, indexPath: IndexPath, delegate: FavoriteViewDelegate) {
        self.movie = movie
        self.indexPath = indexPath
        self.isFavorite = movie.favorite ?? false
        self.delegate = delegate
        
        self.setHeartImage()
    }
    
    private func setHeartImage() {
        self.heartImageView.image = UIImage(systemName: HeartEnum(isFavorite: self.isFavorite).rawValue)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        self.setFavoriteActivityIndicator.isHidden = false
        self.setFavoriteActivityIndicator.startAnimating()
        
        self.isFavorite.toggle()
        
        self.callSaveFavorite()
    }
    
    private func callSaveFavorite() {
        MovieRamaRest(apiServices: MovieRamaSingleton.sharedInstance.restClient).saveFavorite(for: movie, at: indexPath, completionBlock: {
            self.setFavoriteActivityIndicator.stopAnimating()
            
            self.movie.favorite = self.isFavorite
            MovieRamaHelper().saveFavoriteInfoToDevice(ofMovie: self.movie)
            self.setHeartImage()
            
            self.delegate?.onfavoriteTappedSucceeded(indexPath: self.indexPath)
        }, errorBlock: { error in
            self.setFavoriteActivityIndicator.stopAnimating()
            self.isFavorite.toggle() // undo toggle to maintain the internal state consistent since api call failed to change it

            self.delegate?.onfavoriteTappedError(error: error)
        })
    }
}
