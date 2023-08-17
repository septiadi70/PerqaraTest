//
//  LocalDataSourceTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine
import CoreData

@testable import PerqaraTest

final class LocalDataSourceTests: XCTestCase {
    var persistenceController: TestPersistenceController!
    var dataSource: MockGameLocalDataSource!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        persistenceController = TestPersistenceController(modelName: "Game")
        dataSource = MockGameLocalDataSource(persistenceController: persistenceController)
        bags = Set<AnyCancellable>()
    }
    
    func testGameLocalDataSource() throws {
        try dataSource.saveProduct(gameModel: LocalDataSourceTests.sampleGameModel())
        
        /// Test for get detail game entity
        var error: Error?
        var game: GameEntity?
        dataSource
            .getGameEntity(gameId: LocalDataSourceTests.sampleGameModel().id)
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
        XCTAssertEqual(game?.id, Int32(LocalDataSourceTests.sampleGameModel().id))
        XCTAssertEqual(game?.slug, LocalDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(game?.name, LocalDataSourceTests.sampleGameModel().name)
        
        /// Test for remove game
        try dataSource.removeGameEntity(gameModel: LocalDataSourceTests.sampleGameModel())
        
        /// Test for get game entities
        var games: [GameEntity]?
        dataSource
            .getGameEntities()
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
        XCTAssertTrue(games?.isEmpty ?? true)
    }
    
    static func sampleGameModel() -> GameModel {
        GameModel(id: 1, slug: "slug-1", name: "Game 1")
    }
}
