//
//  MovieDetailsViewController.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import UIKit

protocol MovieDetailsViewControllerDelegate: AnyObject {
    func favoriteUpdatedFromDetails(indexPath: IndexPath)
}

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
    
    private weak var delegate: MovieDetailsViewControllerDelegate?
    
    init(movie: Movie, indexPath: IndexPath, delegate: MovieDetailsViewControllerDelegate) {
        self.movie = movie
        self.indexPath = indexPath
        self.delegate = delegate
        
        super.init(nibName: "MovieDetailsViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpElements()
        self.setMovieDataToScreen()
        self.getRestOfDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.delegate?.favoriteUpdatedFromDetails(indexPath: self.indexPath)
    }
    
    private func setUpElements() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.8)
        
        self.genresLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        self.genresLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.8)
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.dateLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.85)
    }
    
    private func setMovieDataToScreen() {
        self.movieImageView.image = self.movie.image
        self.titleLabel.text = self.movie.title
        self.dateLabel.text = self.movie.date
        self.ratingView.setRating(stars: MovieRating(value: self.movie.rating) ?? .zero)
        self.favoriteView.updateFavoriteView(movie: self.movie, indexPath: self.indexPath, delegate: self)
    }
    
    private func getRestOfDetails() {
        DispatchQueue.global().async {
            MovieRamaRest(apiServices: MovieRamaSingleton.sharedInstance.restClient)
                .getMovieDetails(for: self.movie,
                                 completionBlock: { movie, fields in
                    DispatchQueue.main.async {
                        self.movie = movie
                        self.handleDetailsCallResponse(fields: fields)
                    }
                }, errorBlock: { error in
                    DispatchQueue.main.async {
                        self.presentAlertFor(error: error)
                    }
                })
        }
    }
    
    private func handleDetailsCallResponse(fields: [DetailFieldValue]) {
        self.movieInfoStackView.removeAllArrangedSubviews()
        
        self.genresLabel.text = self.movie.genres
        
        for i in 0..<fields.count {
            let detailCustomView = DetailCustomView()
            detailCustomView.configure(value: fields[i])
            
            self.movieInfoStackView.addArrangedSubview(detailCustomView)
        }
        
        self.getSimiliarMovies()
    }
    
    private func getSimiliarMovies() {
        DispatchQueue.global().async {
            MovieRamaRest(apiServices: MovieRamaSingleton.sharedInstance.restClient)
                .getSimilarMovies(movie: self.movie,
                                  completionBlock: { field in
                    DispatchQueue.main.async {
                        self.handleGetSimilarMoviesResponse(field: field)
                    }
                }, errorBlock: { error in
                    DispatchQueue.main.async {
                        self.presentAlertFor(error: error)
                    }
                })
        }
    }
    
    private func handleGetSimilarMoviesResponse(field: DetailFieldValue) {
        if !field.urls.isEmpty {
            let detailCustomView = DetailCustomView()
            detailCustomView.configure(value: field)
            
            self.movieInfoStackView.addArrangedSubview(detailCustomView)
        }
        
        self.getReviews()
    }
    
    private func getReviews() {
        DispatchQueue.global().async {
            MovieRamaRest(apiServices: MovieRamaSingleton.sharedInstance.restClient)
                .getMovieReviews(for: self.movie,
                                 completionBlock: { fields in
                    DispatchQueue.main.async {
                        self.handleGetReviewsResponse(fields: fields)
                    }
                }, errorBlock: { error in
                    DispatchQueue.main.async {
                        self.presentAlertFor(error: error)
                    }
                })
        }
    }
    
    private func handleGetReviewsResponse(fields: [DetailFieldValue]) {
        fields.forEach({
            let detailCustomView = DetailCustomView()
            detailCustomView.configure(value: $0)
            
            self.movieInfoStackView.addArrangedSubview(detailCustomView)
        })
    }
}

extension MovieDetailsViewController: FavoriteViewDelegate {
    func onfavoriteTappedSucceeded(indexPath: IndexPath) {}
    
    func onfavoriteTappedError(error: Error) {
        self.presentAlertFor(error: error)
    }
}
