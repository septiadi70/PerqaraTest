//
//  GameModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import Foundation

struct GameModel: Decodable {
    var id: Int
    var slug: String
    var name: String
    var released: String?
    var backgroundImage: String?
    var rating: Double?
}
