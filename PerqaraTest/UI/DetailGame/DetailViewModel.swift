//
//  DetailViewModel.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 16/08/23.
//

import Foundation
import Combine

final class DetailViewModel {
    private let useCase: DetailGameUseCaseProtocol
    private let gameId: Int
    private var bags = Set<AnyCancellable>()
    
    @Published var isLoading = false
    @Published var gameModel: GameModel?
    @Published var localGameModel: GameModel?
    @Published var error: Error?
    
    init(useCase: DetailGameUseCaseProtocol, gameId: Int) {
        self.useCase = useCase
        self.gameId = gameId
    }
    
    func loadDetail() {
        useCase
            .getLocalGame(id: gameId)
            .flatMap { gameModel in
                self.localGameModel = gameModel
                return self.useCase.getDetailGame(id: self.gameId)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .failure(let err): self?.error = err
                case .finished: break
                }
            } receiveValue: { [weak self] output in
                self?.gameModel = output
            }
            .store(in: &bags)
    }
    
    func getPublishersName() -> String {
        guard let publishers = gameModel?.publishers else { return "" }
        let names = publishers.map { $0.name }
        return names.joined(separator: ", ")
    }
    
    func getName() -> String {
        gameModel?.name ?? ""
    }
    
    func getReleased() -> String {
        gameModel?.released ?? ""
    }
    
    func getBackgroundImageURL() -> URL? {
        guard let image = gameModel?.backgroundImage else { return nil }
        return URL(string: image)
    }
    
    func getRating() -> Double {
        gameModel?.rating ?? 0.0
    }
    
    func getPlayedCount() -> Int {
        gameModel?.added ?? 0
    }
    
    func getDescription() -> String {
        gameModel?.descriptionRaw ?? ""
    }
    
    func favoriteGame() {
        if localGameModel == nil {
            saveGameModel()
        } else {
            removeGameModel()
        }
    }
    
    func saveGameModel() {
        guard let gameModel else { return }
        do {
            try useCase.saveGameModel(model: gameModel)
            localGameModel = gameModel
        } catch {
            self.error = error
        }
    }
    
    func removeGameModel() {
        guard let gameModel else { return }
        do {
            try useCase.removeGameEntity(gameModel: gameModel)
            localGameModel = nil
        } catch {
            self.error = error
        }
    }
}
