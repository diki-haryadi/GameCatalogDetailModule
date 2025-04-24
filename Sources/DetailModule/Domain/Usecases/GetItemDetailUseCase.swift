//
//  GetItemDetailUseCase.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class GetItemDetailUseCase: UseCase {
    public typealias Parameters = String
    public typealias ReturnType = ItemDetail
    
    private let repository: DetailRepositoryProtocol
    
    public init(repository: DetailRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(parameters: String) async -> Result<ItemDetail, Error> {
        do {
            let detail = try await repository.getItemDetail(id: parameters)
            return .success(detail)
        } catch {
            return .failure(error)
        }
    }
}
