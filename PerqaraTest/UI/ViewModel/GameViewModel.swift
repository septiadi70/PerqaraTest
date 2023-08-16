//
//  GameViewModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import UIKit

final class GameViewModel {
    private let game: GameModel
    
    init(game: GameModel) {
        self.game = game
    }
    
    func getName() -> String {
        game.name
    }
    
    func getReleased() -> String {
        game.released ?? ""
    }
    
    func getBackgroundImageURL() -> URL? {
        guard let image = game.backgroundImage else { return nil }
        return URL(string: image)
    }
    
    func getRating() -> Double {
        game.rating ?? 0.0
    }
}
