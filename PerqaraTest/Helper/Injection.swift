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
    
    private static func provideGameRepository() -> GameRepositoryProtocol {
        let remote = Injection.provideGameRemoteDataSource()
        return GameRepository(remote: remote)
    }
    
    static func provideListGamesViewController() -> ListGamesViewController {
        let useCase = ListGamesUseCase(repository: provideGameRepository())
        let viewModel = ListGamesViewModel(useCase: useCase)
        return ListGamesViewController(viewModel: viewModel)
    }
}
