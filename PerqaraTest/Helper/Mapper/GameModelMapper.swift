//
//  GameModelMapper.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import CoreData

final class GameModelMapper {
    static func mapModelToEntity(model: GameModel, moc: NSManagedObjectContext) -> GameEntity {
        var game = GameEntity(context: moc)
        game.id = Int32(model.id)
        game.slug = model.slug
        game.name = model.name
        game.released = model.released
        game.backgroundImage = model.backgroundImage
        game.rating = model.rating ?? 0.0
//        var publishers: [PublisherModel]?
        game.added = Int32(model.added ?? 0)
        game.descriptionRaw = model.descriptionRaw
        return game
    }
    
    static func mapEntityToModel(entity: GameEntity) -> GameModel {
        GameModel(id: Int(entity.id),
                  slug: entity.slug ?? "",
                  name: entity.name ?? "",
                  released: entity.released,
                  backgroundImage: entity.backgroundImage,
                  rating: entity.rating,
                  publishers: [],
                  added: Int(entity.added),
                  descriptionRaw: entity.descriptionRaw)
    }
}
