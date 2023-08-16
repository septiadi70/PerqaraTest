//
//  GameLocalDataSource.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import CoreData
import Combine

final class GameLocalDataSource: GameLocalDataSourceProtocol {
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func saveProduct(gameModel model: GameModel) throws {
        let moc = persistenceController.viewContext
        let _ = GameModelMapper.mapModelToEntity(model: model, moc: moc)
        try moc.save()
    }
    
    func removeGameEntity(gameModel: GameModel) throws {
        let fetchRequest = NSFetchRequest<GameEntity>(entityName: "GameEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %i", gameModel.id)
        guard let gameEntity = try persistenceController.viewContext.fetch(fetchRequest).first
        else { throw AppError.custom(message: "Delete entity failed") }
        try persistenceController.delete(gameEntity)
    }
    
    func getGameEntity(gameId: Int) -> AnyPublisher<GameEntity?, Error> {
        Future<GameEntity?, Error> { [weak self] completion in
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
}
