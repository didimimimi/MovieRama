//
//  LoadingTableViewCell.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 26/10/23.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!

    static let cellId = "LoadingTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpCell()
    }
    
    private func setUpCell() {
        self.selectionStyle = .none

        self.loadingActivityIndicator.color = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.6)
        
        self.loadingLabel.font = UIFont.systemFont(ofSize: 12)
        self.loadingLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.6)
    }
    
    func beginLoading() {
        self.loadingActivityIndicator.startAnimating()
        self.loadingActivityIndicator.isHidden = false
        
        self.loadingLabel.text = "Loading more..."
    }
}
