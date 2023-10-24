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
        view.backgroundColor = .white
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
        
        view.addSubview(backgroundView)
        view.addSubview(movieLabel)
        view.addSubview(ramaLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            movieLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            ramaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ramaLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        movieLabel.center.x = -view.bounds.width - movieLabel.bounds.width / 2
        ramaLabel.center.x = view.bounds.width + ramaLabel.bounds.width / 2
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.movieLabel.center.x = self.view.center.x - (self.ramaLabel.bounds.width / 2)
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
                self.ramaLabel.center.x = self.view.center.x + (self.ramaLabel.bounds.width / 2)
            }) { _ in
                let mainViewController = MovieListViewController()
                mainViewController.modalPresentationStyle = .fullScreen
                self.present(mainViewController, animated: false, completion: nil)
            }
        }
        
    }
    
}
