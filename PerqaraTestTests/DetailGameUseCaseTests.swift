//
//  DetailGameUseCaseTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class DetailGameUseCaseTests: XCTestCase {
    var useCase: MockDetailGameUseCase!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCase = MockDetailGameUseCase()
        bags = Set<AnyCancellable>()
    }
    
    func testGetDetailGame() throws {
        var game: GameModel?
        var error: Error?
        
        useCase
            .getDetailGame(id: 1)
            .sink { completion in
                if case .failure(let err) = completion {
                    error = err
                }
            } receiveValue: { output in
                game = output
            }
            .store(in: &bags)
        
        XCTAssertNil(error)
        XCTAssertNotNil(game)
        XCTAssertEqual(game?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(game?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(game?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    func testSaveGameModel() throws {
        try useCase.saveGameModel(model: RemoteDataSourceTests.sampleGameModel())
        XCTAssertEqual(useCase.saveGameModel?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(useCase.saveGameModel?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(useCase.saveGameModel?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    func testRemoveGameModel() throws {
        try useCase.removeGameEntity(gameModel: RemoteDataSourceTests.sampleGameModel())
        XCTAssertEqual(useCase.removeGameModel?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(useCase.removeGameModel?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(useCase.removeGameModel?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    func testGetLocalGame() throws {
        var game: GameModel?
        var error: Error?
        
        useCase
            .getLocalGame(id: 1)
            .sink { completion in
                if case .failure(let err) = completion {
                    error = err
                }
            } receiveValue: { output in
                game = output
            }
            .store(in: &bags)
        
        XCTAssertNil(error)
        XCTAssertNotNil(game)
        XCTAssertEqual(game?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(game?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(game?.name, RemoteDataSourceTests.sampleGameModel().name)
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
