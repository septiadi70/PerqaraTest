//
//  GameRemoteDataSource.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation
import Combine

final class GameRemoteDataSource: GameRemoteDataSourceProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getListGames(page: Int?,
                      pageSize: Int?,
                      search: String?) -> AnyPublisher<ListGameResponse, Error> {
        Future<ListGameResponse, Error> { [weak self] completion in
            guard let ws = self else { return }
            let endpoint = GameEndpoint.list(page: page, pageSize: pageSize, search: search)
            ws.networkService.request(endpoint: endpoint,
                                      type: ListGameResponse.self) { result in
                switch result {
                case .success(let response): completion(.success(response))
                case .failure(let error): completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getDetailGame(id: Int) -> AnyPublisher<GameModel, Error> {
        Future<GameModel, Error> { [weak self] completion in
            guard let ws = self else { return }
            let endpoint = GameEndpoint.detail(id: id)
            ws.networkService.request(endpoint: endpoint,
                                      type: GameModel.self) { result in
                switch result {
                case .success(let response): completion(.success(response))
                case .failure(let error): completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
