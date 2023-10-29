//
//  SimilarMovieCollectionViewCell.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import UIKit

protocol SimilarMovieCollectionViewCellDelegate: AnyObject {
    func reloadCell(index: Int)
}

class SimilarMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    static let cellId = "SimilarMovieCollectionViewCell"
    
    private weak var delegate: SimilarMovieCollectionViewCellDelegate?
    private var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.containerView.layer.masksToBounds = false
            self.containerView.layer.cornerRadius = 4
                
            self.posterImageView.layer.masksToBounds = true
            self.posterImageView.layer.cornerRadius = 4
        }
    }
    
    func update(withUrl url: String?,
                atIndex index: Int,
                delegate: SimilarMovieCollectionViewCellDelegate) {
        self.delegate = delegate
        self.index = index
        
        if posterImageView.image == nil {
            MovieRamaHelper().loadImageFrom(urlString: url) { image in
                self.posterImageView.image = image
                self.delegate?.reloadCell(index: index)
            }            
        }
    }

}
