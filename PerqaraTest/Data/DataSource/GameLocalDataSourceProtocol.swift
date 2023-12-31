//
//  GameLocalDataSourceProtocol.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import CoreData
import Combine

protocol GameLocalDataSourceProtocol {
    func saveGame(gameModel model: GameModel) throws
    func removeGameEntity(gameModel: GameModel) throws
    func getGameEntity(gameId: Int) -> AnyPublisher<GameEntity?, Error>
    func getGameEntities() -> AnyPublisher<[GameEntity], Error>
}
