//
//  ToggleFavoriteUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public struct ToggleFavoriteParameters {
    public let id: String
    public let isFavorite: Bool
    
    public init(id: String, isFavorite: Bool) {
        self.id = id
        self.isFavorite = isFavorite
    }
}

public class ToggleFavoriteUseCase: UseCase {
    public typealias Parameters = ToggleFavoriteParameters
    public typealias ReturnType = Bool
    
    private let repository: DetailRepositoryProtocol
    
    public init(repository: DetailRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: ToggleFavoriteParameters) async -> Result<Bool, Error> {
        do {
            try await repository.toggleFavorite(id: parameters.id, isFavorite: parameters.isFavorite)
            return .success(parameters.isFavorite)
        } catch {
            return .failure(error)
        }
    }
}
