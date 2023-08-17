//
//  ListGamesViewModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit
import Combine

final class ListGamesViewModel {
    private let useCase: ListGamesUseCaseProtocol
    private var bags = Set<AnyCancellable>()
    private var page = 1
    
    @Published var isLoading = false
    @Published var search: String?
    @Published var games = [GameModel]()
    @Published var error: Error?
    
    init(useCase: ListGamesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadGames(isLoadMore: Bool = false) {
        guard !isLoading else { return }
        
        if !isLoadMore {
            page = 1
        }
        if let search, search.isEmpty {
            self.search = nil
        }
        
        isLoading = true
        useCase
            .getGames(page: page, search: search)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .failure(let err): self?.error = err
                case .finished: break
                }
            } receiveValue: { [weak self] output in
                if let games = output.results {
                    if isLoadMore {
                        self?.games.append(contentsOf: games)
                    } else {
                        self?.games = games
                    }
                }
                if output.next != nil {
                    self?.page += 1
                }
            }
            .store(in: &bags)
    }
    
    func getGame(index: Int) -> GameModel? {
        guard index < games.count else { return nil }
        return games[index]
    }
    
    func getLastIndexGames() -> Int {
        guard games.count > 0 else { return 0 }
        return games.count - 1
    }
    
    func isLastGamesIndex(index: Int) -> Bool {
        index != 0 && (index == getLastIndexGames())
    }
}
