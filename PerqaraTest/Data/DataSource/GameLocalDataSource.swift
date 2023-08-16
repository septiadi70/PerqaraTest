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
}
