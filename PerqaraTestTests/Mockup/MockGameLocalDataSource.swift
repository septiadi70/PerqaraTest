//
//  MockGameLocalDataSource.swift
//  PerqaraTestTests
//
//  Created by Andi Septiadi on 17/08/23.
//

import Foundation
import CoreData
import Combine

@testable import PerqaraTest

class MockGameLocalDataSource: GameLocalDataSourceProtocol {
    private let persistenceController: TestPersistenceController
    var model: GameModel?
    var gameId: Int?
    
    init(persistenceController: TestPersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func saveGame(gameModel model: GameModel) throws {
        self.model = model
        let entity = GameEntity(context: persistenceController.viewContext)
        entity.id = Int32(model.id)
        entity.slug = model.slug
        entity.name = model.name
        try persistenceController.save()
    }
    
    func removeGameEntity(gameModel: GameModel) throws {
        self.model = gameModel
        let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %i", gameModel.id)
        guard let gameEntity = try persistenceController.viewContext.fetch(fetchRequest).first
        else { throw AppError.custom(message: "Delete entity failed") }
        try persistenceController.delete(gameEntity)
    }
    
    func getGameEntity(gameId: Int) -> AnyPublisher<GameEntity?, Error> {
        self.gameId = gameId
        return Future<GameEntity?, Error> { [weak self] completion in
            guard let ws = self else { return }
            let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %i", gameId)
            do {
                let gameEntity = try ws.persistenceController.viewContext.fetch(fetchRequest).first
                completion(.success(gameEntity))
            } catch {
                completion(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getGameEntities() -> AnyPublisher<[GameEntity], Error> {
        Future<[GameEntity], Error> { [weak self] completion in
            guard let ws = self else { return }
            let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
            let sortDescriptors = NSSortDescriptor(key: #keyPath(GameEntity.released),
                                                   ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptors]
            do {
                let entities = try ws.persistenceController.viewContext.fetch(fetchRequest)
                completion(.success(entities))
            } catch {
                completion(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
