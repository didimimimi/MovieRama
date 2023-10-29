//
//  MovieTableViewCell.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func movieTapped(movie: Movie, indexPath: IndexPath)
    func favoriteTapped(indexPath: IndexPath)
    func favoriteTappedError(error: Error)
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loadingImageIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var favoriteView: FavoriteView!
    
    static let cellId = "MovieTableViewCell"
    
    private var isFavorite = false
    private var movie = Movie()
    private var indexPath = IndexPath()
    
    private weak var delegate: MovieTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpCell()
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
    
            self.movieImageView.layer.masksToBounds = true
            self.movieImageView.layer.cornerRadius = 4
            self.movieImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    private func setUpCell() {
        self.selectionStyle = .none
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.8)
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.dateLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.85)
                
        self.loadingImageIndicatorView.isHidden = true
        self.loadingImageIndicatorView.hidesWhenStopped = true
        self.loadingImageIndicatorView.color = MovieRamaConstants().INDICATOR_COLOR
    }
    
    func configure(withMovie movie: Movie,
                   indexPath: IndexPath,
                   delegate: MovieTableViewCellDelegate) {
        self.movie = movie
        self.indexPath = indexPath
        self.delegate = delegate
        
        self.update()
    }
    
    private func update() {
        self.titleLabel.text = self.movie.title
        self.movieImageView.image = self.movie.image
        self.dateLabel.text = self.movie.date
        self.ratingView.setRating(stars: MovieRating(value: self.movie.rating) ?? .zero)
        self.favoriteView.updateFavoriteView(movie: self.movie, indexPath: self.indexPath, delegate: self)
        self.handleLoading(hide: self.movie.image != nil)
    }
    
    private func handleLoading(hide: Bool) {
        self.loadingImageIndicatorView.isHidden = hide
        hide ? self.loadingImageIndicatorView.stopAnimating() : self.loadingImageIndicatorView.startAnimating()
    }
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        self.delegate?.movieTapped(movie: self.movie, indexPath: self.indexPath)
    }
}

extension MovieTableViewCell: FavoriteViewDelegate {
    func onfavoriteTappedSucceeded(indexPath: IndexPath) {
        self.delegate?.favoriteTapped(indexPath: self.indexPath)
    }
    
    func onfavoriteTappedError(error: Error) {
        self.delegate?.favoriteTappedError(error: error)
    }
}
