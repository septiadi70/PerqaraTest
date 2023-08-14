//
//  GameEndpoint.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

enum GameEndpoint: NetworkEndpointProtocol {
    var baseURL: String {
        "https://api.rawg.io/api"
    }
    
    var path: String {
        switch self {
        default: return "/games"
        }
    }
    
    var headers: [String : String] { [:] }
    
    var method: String { "GET" }
    
    var parameters: NetworkEndpointParameterProtocol? { nil }
}
