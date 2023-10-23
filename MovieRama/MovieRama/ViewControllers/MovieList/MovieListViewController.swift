//
//  MovieListViewController.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setUpMockMovies()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
                
        self.tableView.register(
            UINib.init(
                nibName: MovieTableViewCell.cellId,
                bundle: .main
            ),
            forCellReuseIdentifier: MovieTableViewCell.cellId
        )
    }
    
    private func setUpMockMovies() {
        var movie1 = Movie()
        movie1.id = "movie_1"
        movie1.title = "Movie 1 title"
        movie1.rating = 4
        movie1.date = "Jul 1 2022"
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie1)
        movie1.image = "https://a.ltrbxd.com/resized/sm/upload/xs/d9/wj/nt/scarface-1200-1200-675-675-crop-000000.jpg?v=3e9a08f31f"

        var movie2 = Movie()
        movie2.id = "movie_2"
        movie2.title = "Movie 2 title"
        movie2.rating = 2
        movie2.date = "Jul 7 2022"
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie2)
        movie2.image = "https://cdn.vox-cdn.com/thumbor/q1VhYtuVNtHtWRCb2icgjPzX3Sw=/0x0:1920x1005/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/15969338/surprise_marvel_releases_a_new_full_trailer_and_poster_for_avengers_endgame_social.jpg"
        
        var movie3 = Movie()
        movie3.id = "movie_3"
        movie3.title = "Movie 3 title"
        movie3.rating = 5
        movie3.date = "Dec 27 2000"
        MovieRamaHelper().loadFavoriteInfoFromDevice(forMovie: &movie3)
        movie3.image = "https://occ-0-2794-2219.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABWY9s8-7p1oide16Hv52wGnwTG3oEiIvX-6t5jX5oyvPlaFVGPjjuy_nCtmHZsNMaUTqJbxsjBma3hAQ1d81Nz6nCD0yW9g0QOnt.jpg?r=d11"
        
        self.movies.append(movie1)
        self.movies.append(movie2)
        self.movies.append(movie3)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellId, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = self.movies[indexPath.row]
        cell.configure(withMovie: movie, delegate: self)
        
        return cell
    }
    
    
}

extension MovieListViewController: MovieTableViewCellDelegate {
    func movieTapped(movie: Movie) {
        print("Movie tapped")
    }
    
    func favoriteTapped(movie: Movie) {
        print("Favorite tapped")
    }
}
