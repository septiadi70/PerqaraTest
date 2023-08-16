//
//  DetailGameUseCase.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import Combine

protocol DetailGameUseCaseProtocol {
    func getDetailGame(id: Int) -> AnyPublisher<GameModel, Error>
    func saveGameModel(model: GameModel) throws
    func removeGameEntity(gameModel: GameModel) throws
    func getLocalGame(id: Int) -> AnyPublisher<GameModel?, Error>
}

final class DetailGameUseCase: DetailGameUseCaseProtocol {
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
        repository.getRemoteDetailGame(id: id)
    }
    
    func saveGameModel(model: GameModel) throws {
        try repository.saveGameModel(model: model)
    }
    
    func removeGameEntity(gameModel: GameModel) throws {
        try repository.removeGameEntity(gameModel: gameModel)
    }
    
    func getLocalGame(id: Int) -> AnyPublisher<GameModel?, Error> {
        repository.getLocalGame(gameId: id)
    }
}
