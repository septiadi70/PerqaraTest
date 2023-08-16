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
    func saveProduct(gameModel model: GameModel) throws
}