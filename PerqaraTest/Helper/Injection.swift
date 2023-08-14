//
//  Injection.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation

final class Injection {
    private static func provideGameRemoteDataSource() -> GameRemoteDataSourceProtocol {
        GameRemoteDataSource(networkService: NetworkService())
    }
    
    static func provideGameRepository() -> GameRepositoryProtocol {
        let remote = Injection.provideGameRemoteDataSource()
        return GameRepository(remote: remote)
    }
}
