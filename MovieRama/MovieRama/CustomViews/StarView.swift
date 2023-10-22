//
//  StarView.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 23/10/23.
//

import Foundation
import UIKit

class StarView: UIView {
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(star: StarEnum) {
        super.init(frame: .zero)
        
        let image = UIImage(systemName: star.rawValue)
        image?.withTintColor(MovieRamaConstants().APP_COLOR, renderingMode: .alwaysTemplate)
        
        starImageView.image = image
        self.addSubview(starImageView)
        
        NSLayoutConstraint.activate([
            starImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            starImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            starImageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0),
            starImageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 0),
            starImageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 0),
            starImageView.widthAnchor.constraint(equalToConstant: 12),
            starImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
