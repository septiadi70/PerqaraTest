//
//  RemoteDataSourceTests.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class RemoteDataSourceTests: XCTestCase {
    var dataSource: MockGameDataSource!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        dataSource = MockGameDataSource()
        bags = Set<AnyCancellable>()
    }
    
    func testGetListGames() throws {
        var response: ListGameResponse?
        var error: Error?
        
        dataSource
            .getListGames(page: 1, pageSize: 10, search: "Game")
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
        XCTAssertEqual(dataSource.page, 1)
        XCTAssertEqual(dataSource.pageSize, 10)
        XCTAssertEqual(dataSource.search, "Game")
    }
    
    func testGetDetailGame() throws {
        var game: GameModel?
        var error: Error?
        
        dataSource
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
    
    class MockGameDataSource: GameRemoteDataSourceProtocol {
        var page: Int?
        var pageSize: Int?
        var search: String?
        var gameId: Int?
        
        func getListGames(page: Int?,
                          pageSize: Int?,
                          search: String?) -> AnyPublisher<ListGameResponse, Error> {
            self.page = page
            self.pageSize = pageSize
            self.search = search
            return Just(sampleGameResponse())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func getDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
            self.gameId = id
            return Just(sampleGameModel())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

}
