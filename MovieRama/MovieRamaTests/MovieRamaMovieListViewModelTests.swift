//
//  MovieRamaTests.swift
//  MovieRamaTests
//
//  Created by  Dimitris Tasios Personal on 22/10/23.
//

import XCTest
@testable import MovieRama

final class MovieRamaMovieListViewModelTests: XCTestCase {

    class MockScreen: MovieListViewModelDelegate {
            var viewModel: MovieListViewModel!
            var state: MovieListStates = .dummyState
            var expectation: XCTestExpectation?
            
            init() {
                viewModel = MovieListViewModel(delegate: self)
            }

            func update(state: MovieListStates) {
                self.state = state
                expectation?.fulfill()
            }
        }

        var mockScreen = MockScreen()

        override func setUp() {
            super.setUp()
            mockScreen = MockScreen()
        }


    override func setUpWithError() throws {
        MovieRamaSingleton.sharedInstance.restClient = MovieRamaRestMockServices()
        mockScreen = MockScreen()
    }
    
    private func createNewMockServicesObject(withAmountOfReturnedMovies: Int) {
        let mockServices = MovieRamaRestMockServices()
        mockServices.amountOfMoviesToReturnForPopularMovies = 5
        
        MovieRamaSingleton.sharedInstance.restClient = mockServices
    }

    // Initial state should be a list of movies
    func test_initialState() {
        let expectation = XCTestExpectation(description: "Movies list obtained")

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            switch self.mockScreen.state {
            case .createListState(let movies):
                expectation.fulfill()
                XCTAssertEqual(movies.count, 10)
            default:
                XCTFail("Incorrect State: \(self.mockScreen.state)")
            }
            self.wait(for: [expectation], timeout: 5)
        }
    }
    
//    // Empty state should lead to appropriate state
//    func test_emptyState() {
//        let expectation = XCTestExpectation(description: "Empty movies list obtained")
//
//        self.createNewMockServicesObject(withAmountOfReturnedMovies: 0)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
//            switch self.mockScreen.state {
//            case .emptyListState(let hide):
//                expectation.fulfill()
//                XCTAssert(hide)
//            default:
//                XCTFail("Incorrect State: \(self.mockScreen.state)")
//            }
//            self.wait(for: [expectation], timeout: 5)
//        }
//    }
//
//    // Refresh should refresh available movies
//    func test_refreshMovies() {
//        let expectation = XCTestExpectation(description: "Refresh completed")
//
//        self.mockScreen.viewModel.refresh()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5)
//        switch self.mockScreen.state {
//        case .createListState(let movies):
//            XCTAssertEqual(movies.count, 10)
//        default:
//            XCTFail("Incorrect State: \(self.mockScreen.state)")
//        }
//    }
//
//    // Search should return new movies
//    func test_searchMovie() {
//        self.createNewMockServicesObject(withAmountOfReturnedMovies: 5)
//
//        let expectation = XCTestExpectation(description: "Search completed")
//
//
//        self.mockScreen.viewModel.searchMovie(text: "Test")
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//        }
//
//
//        self.wait(for: [expectation], timeout: 10)
//
//        expectation.fulfill()
//
//        switch self.mockScreen.state {
//        case .createListState(let movies):
//            XCTAssertEqual(movies.count, 5)
//        default:
//            XCTFail("Incorrect State: \(self.mockScreen.state)")
//        }
//
//    }
}
