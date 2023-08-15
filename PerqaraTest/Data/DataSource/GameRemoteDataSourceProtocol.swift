//
//  GameRemoteDataSourceProtocol.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 14/08/23.
//

import Foundation
import Combine

protocol GameRemoteDataSourceProtocol {
    func getListGames(page: Int?,
                      pageSize: Int?,
                      search: String?) -> AnyPublisher<ListGameResponse, Error>
}
