//
//  DetailCustomView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation
import UIKit

@IBDesignable
class DetailCustomView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var informationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var urls = [String]()
    
    static let viewId = "DetailCustomView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp(forNib: DetailCustomView.viewId) {
            self.setUpCell()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp(forNib: DetailCustomView.viewId) {
            self.setUpCell()
        }
    }
    
    private func setUpCell() {
        self.setUpLabels()
        self.setUpCollectionView()
        self.setupCollectionViewFlowLayout()
    }
    
    private func setUpLabels() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel.textColor = MovieRamaConstants().CYAN_COLOR
        self.titleLabel.isHidden = false
        
        self.informationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.informationLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.85)
        self.informationLabel.isHidden = false
        
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.descriptionLabel.textColor = .black
        self.descriptionLabel.isHidden = false
    }
    
    func configure(value: DetailFieldValue) {
        self.set(text: value.title?.rawValue, to: titleLabel)
        self.set(text: value.information, to: informationLabel)
        self.set(text: value.description, to: descriptionLabel)
        self.setValuesForDataSource(texts: value.urls)
        
        self.layoutIfNeeded()
    }
    
    private func set(text textValue: String?, to label: UILabel) {
        if let textValue = textValue {
            label.isHidden = false
            label.text = textValue
        } else {
            label.isHidden = true
        }
    }
    
    private func setValuesForDataSource(texts textValues: [String]?) {
        if let textValues = textValues {
            self.collectionView.isHidden = false
            self.urls = textValues
        } else {
            self.collectionView.isHidden = true
        }
    }
    
    private func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(
            UINib.init(
                nibName: SimilarMovieCollectionViewCell.cellId,
                bundle: .main
            ),
            forCellWithReuseIdentifier: SimilarMovieCollectionViewCell.cellId
        )
        
        self.collectionView.isHidden = false
    }
    
    private func setupCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension DetailCustomView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCollectionViewCell.cellId, for: indexPath) as? SimilarMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.item
        let url = self.urls[index]
        movieCell.update(withUrl: url, atIndex: index, delegate: self)
        
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension DetailCustomView: SimilarMovieCollectionViewCellDelegate {
    func reloadCell(index: Int) {
        self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}
