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
    
    init(useCase: ListFavoritesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadGames() {
        useCase
            .getGames()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let err): print(err)
                case .finished: break
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
}
