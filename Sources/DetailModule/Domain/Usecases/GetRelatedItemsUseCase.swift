//
//  GetRelatedItemsUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class GetRelatedItemsUseCase: UseCase {
    public typealias Parameters = String
    public typealias ReturnType = [RelatedItem]
    
    private let repository: DetailRepositoryProtocol
    
    public init(repository: DetailRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: String) async -> Result<[RelatedItem], Error> {
        do {
            let relatedItems = try await repository.getRelatedItems(id: parameters)
            return .success(relatedItems)
        } catch {
            return .failure(error)
        }
    }
}
