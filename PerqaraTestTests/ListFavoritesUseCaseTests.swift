//
//  ListFavoritesUseCaseTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class ListFavoritesUseCaseTests: XCTestCase {

    var useCase: MockListFavoritesUseCase!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCase = MockListFavoritesUseCase()
        bags = Set<AnyCancellable>()
    }
    
    func testGetGames() throws {
        var games: [GameModel]?
        var error: Error?
        
        useCase
            .getGames()
            .sink { completion in
                if case .failure(let err) = completion {
                    error = err
                }
            } receiveValue: { output in
                games = output
            }
            .store(in: &bags)
        
        XCTAssertNil(error)
        XCTAssertNotNil(games)
        XCTAssertEqual(games?.count, RemoteDataSourceTests.sampleGameResponse().count)
    }
    
    func testRemoveGameModel() throws {
        try useCase.removeGameEntity(gameModel: RemoteDataSourceTests.sampleGameModel())
        XCTAssertEqual(useCase.removeGameModel?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(useCase.removeGameModel?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(useCase.removeGameModel?.name, RemoteDataSourceTests.sampleGameModel().name)
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
