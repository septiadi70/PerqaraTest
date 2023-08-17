//
//  ListGamesViewModelTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class ListGamesViewModelTests: XCTestCase {
    var useCase: MockListGamesUseCase!
    var viewModel: ListGamesViewModel!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCase = MockListGamesUseCase()
        viewModel = ListGamesViewModel(useCase: useCase)
        bags = Set<AnyCancellable>()
    }
    
    func testLoadGames() throws {
        viewModel.loadGames()
        let expectations = self.expectation(description: "Results")
        viewModel.$games
            .dropFirst()
            .sink { output in
                XCTAssertEqual(output.count, ListGamesViewModelTests.sampleGameModels().count)
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
    }
    
    func testGetGame() throws {
        viewModel.loadGames()
        
        let expectations = self.expectation(description: "Results")
        viewModel.$games
            .dropFirst()
            .sink { output in
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
        
        let game = viewModel.getGame(index: 0)
        XCTAssertNotNil(game)
    }
    
    func testLastIndexGames() throws {
        viewModel.loadGames()
        
        let expectations = self.expectation(description: "Results")
        viewModel.$games
            .dropFirst()
            .sink { output in
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
        
        let index = viewModel.getLastIndexGames()
        XCTAssertEqual(index, (ListGamesViewModelTests.sampleGameModels().count - 1))
    }
    
    func testValidationLastGamesIndex() throws {
        viewModel.loadGames()
        
        let expectations = self.expectation(description: "Results")
        viewModel.$games
            .dropFirst()
            .sink { output in
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
        
        let bool = viewModel.isLastGamesIndex(index: 2)
        XCTAssertTrue(bool)
    }
    
    static func sampleGameResponse() -> ListGameResponse {
        return ListGameResponse(count: 3,
                                next: nil,
                                previous: nil,
                                results: sampleGameModels())
    }
    
    static func sampleGameModels() -> [GameModel] {
        [
            GameModel(id: 1, slug: "slug-1", name: "Game 1"),
            GameModel(id: 2, slug: "slug-2", name: "Game 2"),
            GameModel(id: 3, slug: "slug-3", name: "Game 3")
        ]
    }
    
    class MockListGamesUseCase: ListGamesUseCaseProtocol {
        func getGames(page: Int?, search: String?) -> AnyPublisher<ListGameResponse, Error> {
            return Just(sampleGameResponse())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
