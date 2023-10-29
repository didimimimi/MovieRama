//
//  MovieDetailsViewController.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var favoriteView: FavoriteView!
    
    @IBOutlet weak var movieInfoStackView: UIStackView!
    
    private var movie = Movie()
    private var indexPath = IndexPath() // for dismiss
    
    init(movie: Movie, indexPath: IndexPath) {
        self.movie = movie
        self.indexPath = indexPath
        
        super.init(nibName: "MovieDetailsViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpElements()
    }
    
    private func setUpElements() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.8)
        
        self.genresLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.genresLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.8)

        self.dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.dateLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.85)
    }
    
    private func setMovieDataToScreen() {
        self.movieImageView.image = self.movie.image
        self.titleLabel.text = self.movie.title
        self.genresLabel.text = self.movie.genres.joined(separator: ", ")
        self.dateLabel.text = self.movie.date
        self.ratingView.setRating(stars: MovieRating(value: self.movie.rating) ?? .zero)
        self.favoriteView.updateFavoriteView(movie: self.movie, indexPath: self.indexPath, delegate: self)
    }
}

extension MovieDetailsViewController: FavoriteViewDelegate {
    func onfavoriteTappedSucceeded(indexPath: IndexPath) {}
    
    func onfavoriteTappedError(error: Error) {
        self.presentAlertFor(error: error)
    }
}
