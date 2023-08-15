//
//  GameRepositoryProtocol.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
    func getRemoteListGames(page: Int?,
                            pageSize: Int?,
                            search: String?) -> AnyPublisher<ListGameResponse, Error>
    func getRemoteDetailGame(id: Int) -> AnyPublisher<GameModel, Error>
}
