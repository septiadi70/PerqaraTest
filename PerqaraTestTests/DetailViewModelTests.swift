//
//  DetailViewModelTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class DetailViewModelTests: XCTestCase {
    var useCase: MockDetailGameUseCase!
    var viewModel: DetailViewModel!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCase = MockDetailGameUseCase()
        viewModel = DetailViewModel(useCase: useCase, gameId: 1)
        bags = Set<AnyCancellable>()
    }
    
    func testLoadDetail() throws {
        viewModel.loadDetail()
        let expectations = self.expectation(description: "Results")
        viewModel.$gameModel
            .dropFirst()
            .sink { output in
                XCTAssertEqual(output?.id, DetailViewModelTests.sampleGameModel().id)
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
    }
    
    func testGameParameters() throws {
        viewModel.loadDetail()
        
        let expectations = self.expectation(description: "Results")
        viewModel.$gameModel
            .dropFirst()
            .sink { output in
                XCTAssertEqual(output?.id, DetailViewModelTests.sampleGameModel().id)
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
        
        XCTAssertEqual(viewModel.getName(), DetailViewModelTests.sampleGameModel().name)
        XCTAssertEqual(viewModel.getReleased(), "")
    }
    
    func testLikeGame() throws {
        viewModel.loadDetail()
        
        let expectations = self.expectation(description: "Results")
        viewModel.$gameModel
            .dropFirst()
            .sink { output in
                self.viewModel.localGameModel = nil
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
        
        viewModel.favoriteGame()
        XCTAssertEqual(viewModel.gameModel?.id, viewModel.localGameModel?.id)
    }
    
    func testUnlikeGame() throws {
        viewModel.loadDetail()
        
        let expectations = self.expectation(description: "Results")
        viewModel.$gameModel
            .dropFirst()
            .sink { output in
                self.viewModel.localGameModel = output
                expectations.fulfill()
            }
            .store(in: &bags)
        wait(for: [expectations], timeout: 10)
        
        viewModel.favoriteGame()
        XCTAssertNil(viewModel.localGameModel)
    }
    
    static func sampleGameModel() -> GameModel {
        GameModel(id: 1, slug: "slug-1", name: "Game 1")
    }

    class MockDetailGameUseCase: DetailGameUseCaseProtocol {
        var saveGameModel: GameModel?
        var removeGameModel: GameModel?
        
        func getDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
            Just(sampleGameModel())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func saveGameModel(model: GameModel) throws {
            self.saveGameModel = model
        }
        
        func removeGameEntity(gameModel: GameModel) throws {
            self.removeGameModel = gameModel
        }
        
        func getLocalGame(id: Int) -> AnyPublisher<GameModel?, Error> {
            Just(sampleGameModel())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

}
