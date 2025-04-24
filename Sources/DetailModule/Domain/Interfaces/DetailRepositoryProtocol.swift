//
//  DetailRepositoryProtocol.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

public protocol DetailRepositoryProtocol {
    func getItemDetail(id: String) async throws -> ItemDetail
    func getRelatedItems(id: String) async throws -> [RelatedItem]
    func toggleFavorite(id: String, isFavorite: Bool) async throws
    func isFavorite(id: String) -> Bool
}
