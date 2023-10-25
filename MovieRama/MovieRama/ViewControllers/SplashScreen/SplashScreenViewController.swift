//
//  SplashScreenViewController.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 24/10/23.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = MovieRamaConstants().CYAN_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ramaLabel: UILabel = {
        let label = UILabel()
        label.text = "Rama"
        label.textColor = MovieRamaConstants().CYAN_COLOR
        label.font = UIFont.systemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMovies()
        addSubviewsToView()
        addConstraintsToSubviews()
        animateSplashScreen()
    }
    
    private func getMovies() {
        MovieRamaSingleton.sharedInstance.moviesFromSplashScreen =  MovieRamaHelper().setUpMockMovies()
        
        MovieRamaHelper().loadImagesFor(movies: &MovieRamaSingleton.sharedInstance.moviesFromSplashScreen) { _ in
            print("Images loaded")
        }
    }
    
    private func addSubviewsToView() {
        view.addSubview(backgroundView)
        view.addSubview(movieLabel)
        view.addSubview(ramaLabel)
    }
    
    private func addConstraintsToSubviews() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            movieLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            movieLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ramaLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            ramaLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func animateSplashScreen() {
        UIView.animate(withDuration: 0, delay: 1, animations: {
            self.backgroundView.backgroundColor = .black
        }) { _ in
            UIView.animate(withDuration: 0, delay: 1, animations: {
                self.backgroundView.backgroundColor = .white
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.presentMainScreen()                    
                }
            }
        }
    }
    
    private func presentMainScreen() {
        let mainViewController = MovieListViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: false, completion: nil)
    }
}
