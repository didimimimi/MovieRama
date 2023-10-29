//
//  FavoriteView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation
import UIKit

protocol FavoriteViewDelegate: AnyObject {
    func favoriteTapped(movie: Movie, indexPath: IndexPath, favorite: Bool)
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
            self.setUpCell()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp(forNib: FavoriteView.viewId) {
            self.setUpCell()
        }
    }
    
    private func setUpCell() {
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
        
        self.heartImageView.image = UIImage(systemName: HeartEnum(isFavorite: self.isFavorite).rawValue)
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        print("Current favorite: \(self.isFavorite), movie favorite: \(movie.favorite)\n")
        self.setFavoriteActivityIndicator.isHidden = false
        self.setFavoriteActivityIndicator.startAnimating()
        
        self.isFavorite.toggle()
        self.delegate?.favoriteTapped(movie: self.movie, indexPath: self.indexPath, favorite: self.isFavorite)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.setFavoriteActivityIndicator.stopAnimating()
        }

    }
}
