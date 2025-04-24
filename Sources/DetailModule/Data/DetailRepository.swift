//
//  DetailRepository.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class DetailRepository: DetailRepositoryProtocol {
    private let remoteDataSource: DetailRemoteDataSource
    private let localDataSource: DetailLocalDataSource
    private let logger = Logger(category: "DetailRepository")
    
    public init(
        remoteDataSource: DetailRemoteDataSource,
        localDataSource: DetailLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    public func getItemDetail(id: String) async throws -> ItemDetail {
        // Try to get from cache first
        if let cachedDetail = try? localDataSource.getItemDetail(id: id) {
            logger.log("Returning cached item detail for ID: \(id)", level: .debug)
            return cachedDetail
        }
        
        // Fetch from remote if not in cache
        logger.log("Fetching remote item detail for ID: \(id)", level: .debug)
        let detailDTO = try await remoteDataSource.fetchItemDetail(id: id)
        let itemDetail = detailDTO.toDomain()
        
        // Cache the result
        try? localDataSource.saveItemDetail(itemDetail)
        
        return itemDetail
    }
    
    public func getRelatedItems(id: String) async throws -> [RelatedItem] {
        // Try cache first
        if let cachedRelatedItems = try? localDataSource.getRelatedItems(id: id) {
            logger.log("Returning cached related items for ID: \(id)", level: .debug)
            return cachedRelatedItems
        }
        
        // Fetch from remote
        logger.log("Fetching remote related items for ID: \(id)", level: .debug)
        let relatedItemsDTO = try await remoteDataSource.fetchRelatedItems(id: id)
        let relatedItems = relatedItemsDTO.map { $0.toDomain() }
        
        // Cache the result
        try? localDataSource.saveRelatedItems(id: id, items: relatedItems)
        
        return relatedItems
    }
    
    public func toggleFavorite(id: String, isFavorite: Bool) async throws {
        if isFavorite {
            try await remoteDataSource.addToFavorites(id: id)
            try localDataSource.markAsFavorite(id: id)
        } else {
            try await remoteDataSource.removeFromFavorites(id: id)
            try localDataSource.unmarkAsFavorite(id: id)
        }
    }
    
    public func isFavorite(id: String) -> Bool {
        return localDataSource.isFavorite(id: id)
    }
}
