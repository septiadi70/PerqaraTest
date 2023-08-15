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
        
        if let parameters = endpoint.queryParameter {
            let queryItems = parameters
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
    
    func request<T: Decodable>(endpoint: NetworkEndpointProtocol,
                               type: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        var request: URLRequest?
        
        do {
            request = try getRequest(endpoint: endpoint)
        } catch {
            completion(.failure(error))
        }
        
        guard let request else { return }
        
        let task = URLSession
            .shared
            .dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let object = try decoder.decode(type, from: data)
                        completion(.success(object))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
         
        task.resume()
    }
}
