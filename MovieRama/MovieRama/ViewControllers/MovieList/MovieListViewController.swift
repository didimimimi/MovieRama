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
    
    private var refreshControl = UIRefreshControl()
    
    private var currentMovies = [Movie]()
    private var viewModel = MovieListViewModel()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchUI()
        self.setUpViewModel()
        self.setUpLoadingIndicator()
        self.setUpRefreshControl()
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
    
    private func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = MovieRamaConstants().CYAN_COLOR
        self.refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc private func handleRefreshControl() {
        self.viewModel.refresh()
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
        cell.configure(withMovie: movie, delegate: self)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            self.viewModel.loadMoreMovies()
        }
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
        case .moveToDetailsScreenState(let movie):
            self.handleMoveToDetailsScreenState(ofMovie: movie)
        case .endRefreshState:
            self.handleEndRefreshState()
        case .createListState(let movies):
            self.handleCreateListState(movies: movies)
        case .appendToListState(let movies, let indexPaths):
            self.handleAppendToListState(movies: movies, indexPaths: indexPaths)
        case .refreshListState(let indexPath):
            self.handleRefreshListState(indexPath: indexPath)
        }
    }
    
    private func handleMoveToDetailsScreenState(ofMovie movie: Movie) {
        print("open details of movie \"\(movie.title ?? "")\"")
    }
    
    private func handleEndRefreshState() {
        self.refreshControl.endRefreshing()
    }
    
    private func handleCreateListState(movies: [Movie]) {
        self.currentMovies = movies
        self.tableView.reloadData()
    }
    
    private func handleAppendToListState(movies: [Movie], indexPaths: [IndexPath]) {
        self.currentMovies.append(contentsOf: movies)
        self.tableView.insertRows(at: indexPaths, with: .none)
        self.tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    private func handleRefreshListState(indexPath: IndexPath) {
        print("Refreshed")
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
