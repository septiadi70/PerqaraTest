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
    
    init(useCase: ListFavoritesUseCaseProtocol) {
        self.useCase = useCase
    }
}
