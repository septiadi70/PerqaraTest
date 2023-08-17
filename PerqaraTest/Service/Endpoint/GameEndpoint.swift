//
//  GameEndpoint.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

enum GameEndpoint: NetworkEndpointProtocol {
    case list(page: Int?, pageSize: Int?, search: String?)
    case detail(id: Int)
    
    var baseURL: String {
        "https://api.rawg.io/api"
    }
    
    var path: String {
        switch self {
        case .list: return "/games"
        case .detail(let id): return "/games/\(id)"
        }
    }
    
    var headers: [String : String] { [:] }
    
    var method: String { "GET" }
    
    var queryParameter: [String : String]? {
        var params: [String: String] = ["key": NetworkConfig.apiKey]
        
        switch self {
        case .list(let page, let pageSize, let search):
            if let page { params["page"] = String(page) }
            if let pageSize { params["page_size"] = String(pageSize) }
            if let search { params["search"] = search }
            
        default: break
        }
        
        return params
    }
}
