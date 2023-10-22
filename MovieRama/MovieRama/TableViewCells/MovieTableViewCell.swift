//
//  MovieTableViewCell.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func movieTapped(movie: Movie)
    func favoriteTapped(movie: Movie)
}

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    static let cellId = "MovieTableViewCell"
    
    private var isFavorited = false
    private var movie = Movie()
    
    private weak var delegate: MovieTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
    }
    
    private func setUpCell() {
        self.selectionStyle = .none
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.8)
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.dateLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.85)
        
        self.favoriteImageView.image = UIImage(systemName: "heart")
        self.favoriteImageView.tintColor = .red.withAlphaComponent(0.8)
    }
    
    func configure(withMovie movie: Movie, delegate: MovieTableViewCellDelegate) {
        self.movie = movie
        self.delegate = delegate
        
        self.update()
    }
    
    private func update() {
        self.titleLabel.text = self.movie.title
        self.movieImageView.load(stringUrl: self.movie.image)
        self.dateLabel.text = self.movie.date
        self.ratingView.setRating(stars: MovieRating(value: self.movie.rating) ?? .zero)
        
        self.setUpFavorite()
    }
    
    private func setUpFavorite() {
        self.movie.loadFavoriteInfoFromDevice()
        
        if let movieIsFavorite = self.movie.favoriteInfo?.favorite {
            self.isFavorited = movieIsFavorite
        } else {
            self.isFavorited = false
        }
        
        self.updateFavoriteIcon()
    }
    
    private func updateFavoriteIcon() {
        if self.isFavorited {
            self.favoriteImageView.image = UIImage(systemName: "heart.fill")
        } else {
            self.favoriteImageView.image = UIImage(systemName: "heart")
        }
    }
    
    @IBAction func mainButtonTapped(_ sender: Any) {
        self.delegate?.movieTapped(movie: self.movie)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.isFavorited.toggle()
        
        guard let movieFavoriteInfo = self.movie.favoriteInfo else {
            return
        }
        
        movieFavoriteInfo.favorite = isFavorited
        movieFavoriteInfo.saveFavoriteInfoToDevice()
        
        self.updateFavoriteIcon()
        self.delegate?.favoriteTapped(movie: self.movie)
    }
}
