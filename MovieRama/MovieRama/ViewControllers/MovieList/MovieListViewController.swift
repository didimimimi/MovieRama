//
//  MovieListViewController.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import UIKit

class MovieListViewController: UIViewController {
    
    enum CellType {
        case movieCell(movie: Movie)
        case loadMoreCell
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var refreshControl = UIRefreshControl()
    
    private var currentCellTypes = [CellType]()
    private var viewModel = MovieListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchUI()
        self.setUpViewModel()
        self.setUpRefreshControl()
        self.setUpEmptyLabel()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        
        self.tableView.register(
            UINib.init(
                nibName: MovieTableViewCell.cellId,
                bundle: .main
            ),
            forCellReuseIdentifier: MovieTableViewCell.cellId
        )
        
        self.tableView.register(
            UINib.init(
                nibName: LoadingTableViewCell.cellId,
                bundle: .main
            ),
            forCellReuseIdentifier: LoadingTableViewCell.cellId
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
    
    private func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = MovieRamaConstants().CYAN_COLOR
        self.refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc private func handleRefreshControl() {
        self.viewModel.refresh()
    }
    
    private func setUpEmptyLabel() {
        self.emptyLabel.font = UIFont.systemFont(ofSize: 24)
        self.emptyLabel.textColor = MovieRamaConstants().CYAN_COLOR
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.currentCellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = self.currentCellTypes[indexPath.row]
        
        switch cellType {
        case .movieCell(movie: let movie):
            guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellId, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            
            movieCell.configure(withMovie: movie, delegate: self)
            
            return movieCell
        case .loadMoreCell:
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellId, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            
            loadingCell.beginLoading()
            
            return loadingCell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            self.viewModel.scrolledToBottom()
        }
    }
    
    private func addLoadingCell() {
        if !loadingCellExists() && !self.currentCellTypes.isEmpty {
            self.currentCellTypes.append(.loadMoreCell)
            
            let indexPath = IndexPath(row: currentCellTypes.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .none)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func removeLoadingCell() {
        if loadingCellExists() {
            self.tableView.performBatchUpdates({
                self.tableView.deleteRows(at: [IndexPath(row: self.currentCellTypes.count - 1, section: 0)], with: .none)
                self.currentCellTypes.removeLast()
            })
        }
    }
    
    private func loadingCellExists() -> Bool {
        if !self.currentCellTypes.isEmpty, case .loadMoreCell = self.currentCellTypes[self.currentCellTypes.count - 1] {
            return true
        } else {
            return false
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
        print(state)
        
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
        case .noMoreMoviesState:
            self.handleNoMoreMoviesState()
        case .emptyListState(let hide):
            self.handleEmptyListState(hide: hide)
        case .addLoadingCellState:
            self.handleAddLoadingCellState()
        case .removeLoadingCellState:
            self.handleRemoveLoadingCellState()
        case .errorState(let error):
            self.handleErrorState(error: error)
        }
    }
    
    private func handleMoveToDetailsScreenState(ofMovie movie: Movie) {
        print("open details of movie \"\(movie.title ?? "")\"")
    }
    
    private func handleEndRefreshState() {
        self.refreshControl.endRefreshing()
    }
    
    private func handleCreateListState(movies: [Movie]) {
        self.currentCellTypes.removeAll()
        
        movies.forEach({ movie in
            self.currentCellTypes.append(.movieCell(movie: movie))
        })
        
        self.tableView.reloadData()
    }
    
    private func handleAppendToListState(movies: [Movie], indexPaths: [IndexPath]) {
        self.tableView.performBatchUpdates({
            self.removeLoadingCell()
            
            movies.forEach({ movie in
                self.currentCellTypes.append(.movieCell(movie: movie))
            })
            
            self.tableView.insertRows(at: indexPaths, with: .none)
        }) { _ in
            self.tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    private func handleRefreshListState(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func handleNoMoreMoviesState() {
        self.removeLoadingCell()
    }
    
    private func handleEmptyListState(hide: Bool) {
        self.emptyView.isHidden = hide
    }
    
    private func handleAddLoadingCellState() {
        self.addLoadingCell()
    }
    
    private func handleRemoveLoadingCellState() {
//        self.removeLoadingCell()
    }
    
    private func handleErrorState(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true)
    }
}
