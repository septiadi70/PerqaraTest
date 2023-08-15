//
//  GameAddedStatusModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import Foundation

struct GameAddedStatusModel: Decodable {
    var yet: Int
    var owned: Int
    var beaten: Int
    var toplay: Int
    var dropped: Int
    var playing: Int
}
