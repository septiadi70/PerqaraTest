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
}

final class DetailGameUseCase: DetailGameUseCaseProtocol {
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
        repository.getRemoteDetailGame(id: id)
    }
}