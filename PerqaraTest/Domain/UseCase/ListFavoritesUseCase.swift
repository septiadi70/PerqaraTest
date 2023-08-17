//
//  ListFavoritesUseCase.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import Combine

protocol ListFavoritesUseCaseProtocol {
    func getGames() -> AnyPublisher<[GameModel], Error>
}

final class ListFavoritesUseCase: ListFavoritesUseCaseProtocol {
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGames() -> AnyPublisher<[GameModel], Error> {
        repository.getLocalGames()
    }
}
