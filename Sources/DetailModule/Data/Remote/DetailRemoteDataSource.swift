//
//  DetailRemoteDataSource.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class DetailRemoteDataSource {
    private let apiService: APIServiceProtocol
    private let logger = Logger(category: "DetailRemoteDataSource")
    
    public init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchItemDetail(id: String) async throws -> ItemDetailDTO {
        logger.log("Fetching item detail for ID: \(id)", level: .debug)
        let endpoint = APIEndpoints.getItemDetail(id: id)
        return try await apiService.request(endpoint: endpoint)
    }
    
    func fetchRelatedItems(id: String) async throws -> [RelatedItemDTO] {
        logger.log("Fetching related items for ID: \(id)", level: .debug)
        let endpoint = GenericEndpoint(
            path: "/api/items/\(id)/related",
            method: .get
        )
        return try await apiService.request(endpoint: endpoint)
    }
    
    func addToFavorites(id: String) async throws {
        logger.log("Adding to favorites: \(id)", level: .debug)
        let endpoint = APIEndpoints.addFavorite(itemId: id)
        let _: EmptyResponse = try await apiService.request(endpoint: endpoint)
    }
    
    func removeFromFavorites(id: String) async throws {
        logger.log("Removing from favorites: \(id)", level: .debug)
        let endpoint = APIEndpoints.removeFavorite(itemId: id)
        let _: EmptyResponse = try await apiService.request(endpoint: endpoint)
    }
}
