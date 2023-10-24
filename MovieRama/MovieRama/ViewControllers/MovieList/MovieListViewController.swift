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
    
    private var currentMovies = [Movie]()
    private var viewModel = MovieListViewModel()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchUI()
        self.setUpViewModel()
        self.setUpLoadingIndicator()
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
    
    private func setUpViewModel() {
        self.viewModel = MovieListViewModel(delegate: self)
    }
    
    private func setupSearchUI() {
        searchBar.placeholder = "Search MovieRama"
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.frame.size.height = 40
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
    }
    
    private func setUpLoadingIndicator() {
        loadingIndicator.center = self.tableView.center
        self.view.addSubview(loadingIndicator)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.currentMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellId, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = self.currentMovies[indexPath.row]
        
        if movie.image == nil {
            MovieRamaHelper().loadImageFrom(urlString: movie.imageUrl) { responseImage in
                movie.image = responseImage
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        cell.configure(withMovie: movie, delegate: self)
        
        return cell
    }
}

extension MovieListViewController: MovieTableViewCellDelegate {
    func movieTapped(movie: Movie) {
        self.viewModel.movieTapped(movie: movie)
    }
    
    func favoriteTapped(movie: Movie, favorite: Bool) {
        self.viewModel.favoriteTapped(movie: movie, favorite: favorite)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchMovie(text: searchText)
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func update(state: MovieListStates) {
        switch state {
        case .moveToDetailsScreen(let movie):
            self.handleMoveToDetailsScreen(ofMovie: movie)
        case .loadingState(let show):
            self.handleLoadingState(show: show)
        case .createList(let movies):
            self.handleCreateListState(movies: movies)
        case .appendToList(let movies, let indexPaths):
            self.handleAppendToListState(movies: movies, indexPaths: indexPaths)
        }
    }
    
    private func handleMoveToDetailsScreen(ofMovie movie: Movie) {
        print("open details of movie \"\(movie.title ?? "")\"")
    }
    
    private func handleLoadingState(show: Bool) {
        show ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }
    
    private func handleCreateListState(movies: [Movie]) {
        self.currentMovies = movies
        self.tableView.reloadData()
    }
    
    private func handleAppendToListState(movies: [Movie], indexPaths: [IndexPath]) {
        self.currentMovies.append(contentsOf: movies)
        self.tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}
