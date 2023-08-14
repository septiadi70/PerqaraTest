//
//  NetworkService.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

final class NetworkService {
    private func getRequest(endpoint: NetworkEndpointProtocol) throws -> URLRequest {
        let urlString = endpoint.baseURL + endpoint.path
        
        guard var urlComponent = URLComponents(string: urlString) else {
            throw AppError.server(code: nil)
        }
        
        if let parameters = endpoint.parameters {
            let queryItems = parameters
                .queryParameter()
                .map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponent.queryItems = queryItems
        }
        
        guard let url = urlComponent.url else {
            throw AppError.custom(message: "URL nil")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        for header in endpoint.headers {
            urlRequest.addValue(header.key, forHTTPHeaderField: header.value)
        }
        
        return urlRequest
    }
}
