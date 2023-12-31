//
//  ListFavoritesViewModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import Combine

final class ListFavoritesViewModel {
    private let useCase: ListFavoritesUseCaseProtocol
    private var bags = Set<AnyCancellable>()
    
    @Published var games = [GameModel]()
    @Published var isLoading = false
    @Published var error: Error?
    
    init(useCase: ListFavoritesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadGames() {
        guard !isLoading else { return }
        isLoading = true
        useCase
            .getGames()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let err) = completion {
                    self?.error = err
                }
            } receiveValue: { [weak self] output in
                self?.games = output
            }
            .store(in: &bags)
    }
    
    func getGame(index: Int) -> GameModel? {
        guard index < games.count else { return nil }
        return games[index]
    }
    
    func removeGameModel(index: Int) {
        guard let gameModel = getGame(index: index) else { return }
        do {
            try useCase.removeGameEntity(gameModel: gameModel)
            games.remove(at: index)
        } catch {
            self.error = error
        }
    }
}
