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
    
    private static func provideGameLocalDataSource() -> GameLocalDataSourceProtocol {
        GameLocalDataSource(persistenceController: PersistenceController.shared)
    }
    
    private static func provideGameRepository() -> GameRepositoryProtocol {
        let remote = Injection.provideGameRemoteDataSource()
        let local = Injection.provideGameLocalDataSource()
        return GameRepository(remote: remote, local: local)
    }
    
    static func provideListGamesViewController() -> ListGamesViewController {
        let useCase = ListGamesUseCase(repository: provideGameRepository())
        let viewModel = ListGamesViewModel(useCase: useCase)
        return ListGamesViewController(viewModel: viewModel)
    }
    
    static func provideDetailGameViewController(gameId: Int) -> DetailViewController {
        let useCase = DetailGameUseCase(repository: provideGameRepository())
        let viewModel = DetailViewModel(useCase: useCase, gameId: gameId)
        return DetailViewController(viewModel: viewModel)
    }
    
    static func provideListFavoriteViewController() -> ListFavoritesViewController {
        let useCase = ListFavoritesUseCase(repository: provideGameRepository())
        let viewModel = ListFavoritesViewModel(useCase: useCase)
        return ListFavoritesViewController(viewModel: viewModel)
    }
}
