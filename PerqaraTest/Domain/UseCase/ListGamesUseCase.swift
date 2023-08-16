//
//  ListGamesUseCase.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import Foundation
import Combine

protocol ListGamesUseCaseProtocol {
    func getGames(page: Int?, search: String?) -> AnyPublisher<ListGameResponse, Error>
}

final class ListGamesUseCase: ListGamesUseCaseProtocol {
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGames(page: Int?, search: String?) -> AnyPublisher<ListGameResponse, Error> {
        repository.getRemoteListGames(page: page, pageSize: 20, search: search)
    }
}
