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
    
    private var pendingDispatchWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchUI()
        self.setUpViewModel()
        self.setUpRefreshControl()
        self.setUpEmptyLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        searchBar.searchTextField.keyboardType = .asciiCapable
        searchBar.searchTextField.addDoneButtonOnKeyboard()
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
            
            movieCell.configure(withMovie: movie, indexPath: indexPath, delegate: self)
            
            return movieCell
        case .loadMoreCell:
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellId, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            
            loadingCell.beginLoading()
            
            return loadingCell
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellType = self.currentCellTypes[indexPath.row]
        
        switch cellType {
        case .movieCell(movie: let movie):
            if movie.image == nil {
                MovieRamaHelper().loadImageFrom(urlString: movie.imageUrl) { image in
                    if let image = image {
                        movie.image = image
                    } else {
                        movie.image = UIImage(named: "placeholder")
                    }
                    
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            
        case .loadMoreCell:
            break
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
    func movieTapped(movie: Movie, indexPath: IndexPath) {
        self.viewModel.movieTapped(movie: movie, indexPath: indexPath)
    }

    func favoriteTapped(indexPath: IndexPath) {
        self.viewModel.favoriteTapped(indexPath: indexPath)
    }
    
    func favoriteTappedError(error: Error) {
        self.viewModel.favoriteNotSet(error: error)
    }
    
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingDispatchWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.searchMovie(text: searchText)
        }
        
        pendingDispatchWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func update(state: MovieListStates) {
        
        switch state {
        case .moveToDetailsScreenState(let movie, let indexPath):
            self.handleMoveToDetailsScreenState(ofMovie: movie, at: indexPath)
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
        case .errorState(let error):
            self.handleErrorState(error: error)
        case .reloadCell(let indexPath):
            self.handleReloadCell(indexPath: indexPath)
        case .dummyState:
            break
        }
    }
    
    private func handleMoveToDetailsScreenState(ofMovie movie: Movie, at indexPath: IndexPath) {        
        let movieDetailsVc = MovieDetailsViewController(movie: movie, indexPath: indexPath, delegate: self)
        self.navigationController?.pushViewController(movieDetailsVc, animated: true)
    }
    
    private func handleEndRefreshState() {
        self.refreshControl.endRefreshing()
    }
    
    private func handleCreateListState(movies: [Movie]) {
        self.currentCellTypes.removeAll()
        
        movies.forEach({ movie in
            self.currentCellTypes.append(.movieCell(movie: movie))
        })
        self.tableView.setContentOffset(.zero, animated: false)

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
    
    private func handleErrorState(error: Error) {
        self.presentAlertFor(error: error)
    }
    
    private func handleReloadCell(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension MovieListViewController: MovieDetailsViewControllerDelegate {
    func favoriteUpdatedFromDetails(indexPath: IndexPath) {
        self.viewModel.receivedFavoriteFromDetails(indexPath: indexPath)
    }
}
