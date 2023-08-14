//
//  GameRepository.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

final class GameRepository: GameRepositoryProtocol {
    private let remote: GameRemoteDataSourceProtocol
    
    init(remote: GameRemoteDataSourceProtocol) {
        self.remote = remote
    }
}
