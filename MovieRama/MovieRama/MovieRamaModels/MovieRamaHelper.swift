//
//  MovieRamaHelper.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }
        }
    }
    
    func load(stringUrl: String?) {
        guard let stringUrl = stringUrl, let url = URL(string: stringUrl) else {
            return
        }
        self.load(url: url)
    }
}
