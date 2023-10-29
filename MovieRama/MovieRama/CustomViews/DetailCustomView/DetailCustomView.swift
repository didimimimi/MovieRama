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
    }
    
    private func setUpLabels() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel.textColor = MovieRamaConstants().CYAN_COLOR
        self.titleLabel.isHidden = false
        
        self.informationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.informationLabel.textColor = MovieRamaConstants().CYAN_COLOR.withAlphaComponent(0.5)
        self.informationLabel.isHidden = false
        
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.descriptionLabel.textColor = .black
        self.descriptionLabel.isHidden = false
    }
    
    func configure(value: DetailFieldValue) {
        self.set(text: value.title?.rawValue, to: titleLabel)
        self.set(text: value.information, to: informationLabel)
        self.set(text: value.description, to: descriptionLabel)
        
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
}
