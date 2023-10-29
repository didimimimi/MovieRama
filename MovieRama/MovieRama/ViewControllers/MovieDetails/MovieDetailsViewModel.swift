//
//  MovieDetailsViewModel.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 29/10/23.
//

import Foundation

protocol MovieDetailsViewModelDelegate: AnyObject {
    func update(state: MovieDetailsStates)
}

class MovieDetailsViewModel: MovieDetailsIntents {
    func willLeaveScreen() {
        
    }
    
    
    private weak var delegate: MovieDetailsViewModelDelegate?
    
    init(delegate: MovieDetailsViewModelDelegate) {
        self.delegate = delegate
    }
}
