//
//  ListFavoritesViewModelTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class ListFavoritesViewModelTests: XCTestCase {
    var useCase: MockListFavoritesUseCase!
    var viewModel: ListFavoritesViewModel!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCase = MockListFavoritesUseCase()
        viewModel = ListFavoritesViewModel(useCase: useCase)
        bags = Set<AnyCancellable>()
    }
    
    func testLoadGames() throws {
        viewModel.loadGames()
        let expectations = self.expectation(description: "Results")
        viewModel.$games
            .dropFirst()
            .sink { output in
                XCTAssertEqual(output.count, ListFavoritesViewModelTests.sampleGameModels().count)
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
    
    static func sampleGameModel() -> GameModel {
        GameModel(id: 1, slug: "slug-1", name: "Game 1")
    }
    
    static func sampleGameModels() -> [GameModel] {
        [
            GameModel(id: 1, slug: "slug-1", name: "Game 1"),
            GameModel(id: 2, slug: "slug-2", name: "Game 2"),
            GameModel(id: 3, slug: "slug-3", name: "Game 3")
        ]
    }
    
    class MockListFavoritesUseCase: ListFavoritesUseCaseProtocol {
        var removeGameModel: GameModel?
        
        func getGames() -> AnyPublisher<[GameModel], Error> {
            return Just(sampleGameModels())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func removeGameEntity(gameModel: GameModel) throws {
            self.removeGameModel = gameModel
        }
    }

}
