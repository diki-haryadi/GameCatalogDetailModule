//
//  DetailViewModel.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import Combine
import CoreModule

public class DetailViewModel: ObservableObject {
    private let getItemDetailUseCase: GetItemDetailUseCase
    private let getRelatedItemsUseCase: GetRelatedItemsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase
    private let itemId: String
    private let logger = Logger(category: "DetailViewModel")
    
    @Published public var itemDetail: ItemDetail?
    @Published public var relatedItems: [RelatedItem] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var isFavorite: Bool = false
    
    public init(
        itemId: String,
        getItemDetailUseCase: GetItemDetailUseCase,
        getRelatedItemsUseCase: GetRelatedItemsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase
    ) {
        self.itemId = itemId
        self.getItemDetailUseCase = getItemDetailUseCase
        self.getRelatedItemsUseCase = getRelatedItemsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.checkFavoriteStatusUseCase = checkFavoriteStatusUseCase
    }
    
    public func loadItemDetail() {
        isLoading = true
        errorMessage = nil
        
        Task {
            // Check favorite status first
            let favoriteResult = await checkFavoriteStatusUseCase.execute(parameters: itemId)
            if case .success(let isFavStatus) = favoriteResult {
                await MainActor.run {
                    self.isFavorite = isFavStatus
                }
            }
            
            // Load item details
            let detailResult = await getItemDetailUseCase.execute(parameters: itemId)
            
            switch detailResult {
            case .success(let detail):
                await MainActor.run {
                    self.itemDetail = detail
                }
                
                // After getting details, load related items
                let relatedResult = await getRelatedItemsUseCase.execute(parameters: itemId)
                
                await MainActor.run {
                    self.isLoading = false
                    
                    switch relatedResult {
                    case .success(let items):
                        self.relatedItems = items
                    case .failure(let error):
                        self.logger.log("Error loading related items: \(error.localizedDescription)", level: .error)
                        // We don't set errorMessage here because we already have the main content
                    }
                }
                
            case .failure(let error):
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.logger.log("Error loading item detail: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
    
    public func toggleFavorite() {
        let newStatus = !isFavorite
        
        Task {
            let params = ToggleFavoriteParameters(id: itemId, isFavorite: newStatus)
            let result = await toggleFavoriteUseCase.execute(parameters: params)
            
            await MainActor.run {
                switch result {
                case .success(let status):
                    self.isFavorite = status
                case .failure(let error):
                    self.logger.log("Failed to toggle favorite: \(error.localizedDescription)", level: .error)
                    // Revert UI state in case of failure
                    self.isFavorite = !newStatus
                }
            }
        }
    }
    
    public func refreshData() {
        loadItemDetail()
    }
}
