//
//  ListGameResponse.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import Foundation

struct ListGameResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [GameModel]?
}
