//
//  GameRepositoryTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class GameRepositoryTests: XCTestCase {
    var repository: MockGameRepository!
    var bags: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        repository = MockGameRepository()
        bags = Set<AnyCancellable>()
    }
    
    func testGetRemoteListGames() throws {
        var response: ListGameResponse?
        var error: Error?
        
        repository
            .getRemoteListGames(page: 1, pageSize: 10, search: "Game")
            .sink { completion in
                if case .failure(let err) = completion {
                    error = err
                }
            } receiveValue: { output in
                response = output
            }
            .store(in: &bags)
        
        XCTAssertNil(error)
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.count, RemoteDataSourceTests.sampleGameResponse().count)
        XCTAssertEqual(repository.page, 1)
        XCTAssertEqual(repository.pageSize, 10)
        XCTAssertEqual(repository.search, "Game")
    }
    
    func testGetRemoteDetailGame() throws {
        var game: GameModel?
        var error: Error?
        
        repository
            .getRemoteDetailGame(id: 1)
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
        XCTAssertEqual(repository.gameId, 1)
        XCTAssertEqual(game?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(game?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(game?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    func testSaveGameModel() throws {
        try repository.saveGameModel(model: RemoteDataSourceTests.sampleGameModel())
        XCTAssertEqual(repository.saveGameModel?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(repository.saveGameModel?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(repository.saveGameModel?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    func testRemoveGameModel() throws {
        try repository.removeGameEntity(gameModel: RemoteDataSourceTests.sampleGameModel())
        XCTAssertEqual(repository.removeGameModel?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(repository.removeGameModel?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(repository.removeGameModel?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    func testGetLocalListGames() throws {
        var games: [GameModel]?
        var error: Error?
        
        repository
            .getLocalGames()
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
    
    func testGetLocalDetailGame() throws {
        var game: GameModel?
        var error: Error?
        
        repository
            .getLocalGame(gameId: 1)
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
        XCTAssertEqual(repository.gameId, 1)
        XCTAssertEqual(game?.id, RemoteDataSourceTests.sampleGameModel().id)
        XCTAssertEqual(game?.slug, RemoteDataSourceTests.sampleGameModel().slug)
        XCTAssertEqual(game?.name, RemoteDataSourceTests.sampleGameModel().name)
    }
    
    static func sampleGameResponse() -> ListGameResponse {
        return ListGameResponse(count: 3,
                                next: nil,
                                previous: nil,
                                results: sampleGameModels())
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
    
    class MockGameRepository: GameRepositoryProtocol {
        var page: Int?
        var pageSize: Int?
        var search: String?
        var gameId: Int?
        var saveGameModel: GameModel?
        var removeGameModel: GameModel?
        
        func getRemoteListGames(page: Int?, pageSize: Int?, search: String?) -> AnyPublisher<ListGameResponse, Error> {
            self.page = page
            self.pageSize = pageSize
            self.search = search
            return Just(sampleGameResponse())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func getRemoteDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
            self.gameId = id
            return Just(sampleGameModel())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func saveGameModel(model: GameModel) throws {
            self.saveGameModel = model
        }
        
        func removeGameEntity(gameModel: GameModel) throws {
            self.removeGameModel = gameModel
        }
        
        func getLocalGame(gameId: Int) -> AnyPublisher<GameModel?, Error> {
            self.gameId = gameId
            return Just(sampleGameModel())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func getLocalGames() -> AnyPublisher<[GameModel], Error> {
            return Just(sampleGameModels())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

}
