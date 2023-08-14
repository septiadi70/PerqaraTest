//
//  AppError.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

enum AppError {
    case noInternet
    case server(code: Int?)
    case network(code: Int)
    case custom(message: String)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet: return "No Internet Access"
        case .server: return "Something went wrong while getting the data"
        case .network: return "Something went wrong with the connectivity"
        case .custom(let message): return message
        }
    }
    
    var errorCode: Int? {
        switch self {
        case .server(let code): return code
        case .network(let code): return code
        default: return nil
        }
    }
}
