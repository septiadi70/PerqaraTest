//
//  PublisherModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import Foundation

struct PublisherModel: Decodable {
    var id: Int
    var name: String
    var slug: String
    var gamesCount: Int
    var imageBackground: String?
}
