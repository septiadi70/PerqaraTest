//
//  GameRepository.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation
import Combine

final class GameRepository: GameRepositoryProtocol {
    private let remote: GameRemoteDataSourceProtocol
    
    init(remote: GameRemoteDataSourceProtocol) {
        self.remote = remote
    }
    
    func getRemoteListGames(page: Int?,
                            pageSize: Int?,
                            search: String?) -> AnyPublisher<ListGameResponse, Error> {
        remote.getListGames(page: page, pageSize: pageSize, search: search)
    }
    
    func getRemoteDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
        remote.getDetailGame(id: id)
    }
}
