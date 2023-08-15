//
//  NetworkEndpointProtocol.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

protocol NetworkEndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var method: String { get }
    var queryParameter: [String: String]? { get }
}
