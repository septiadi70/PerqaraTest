//
//  ListGamesUseCase.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import XCTest
import Combine

@testable import PerqaraTest

final class ListGamesUseCase: XCTestCase {
    var useCase: MockListGameUseCase!
    var bags: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCase = MockListGameUseCase()
        bags = Set<AnyCancellable>()
    }
    
    func testGetGames() throws {
        var response: ListGameResponse?
        var error: Error?
        
        useCase
            .getGames(page: 1, search: "Game")
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
        XCTAssertEqual(useCase.page, 1)
        XCTAssertEqual(useCase.search, "Game")
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
    
    class MockListGameUseCase: ListGamesUseCaseProtocol {
        var page: Int?
        var search: String?
        
        func getGames(page: Int?, search: String?) -> AnyPublisher<ListGameResponse, Error> {
            self.page = page
            self.search = search
            return Just(sampleGameResponse())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
