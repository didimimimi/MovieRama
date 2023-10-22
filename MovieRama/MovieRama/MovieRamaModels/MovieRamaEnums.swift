//
//  MovieRamaEnums.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import Foundation

enum MovieRating: Int {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    
    init?(value: Double?) {
        guard let value = value else {
            return nil
        }
        self.init(rawValue: Int(value))
    }
}
