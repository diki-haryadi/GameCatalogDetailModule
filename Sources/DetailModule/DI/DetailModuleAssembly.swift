//
//  DetailModuleAssembly.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import UIKit
import CoreModule

public class DetailModuleAssembly {
    private let coreAssembly: CoreAssembly
    
    public init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    public func makeDetailModule(itemId: String, navigationController: UINavigationController) -> UIViewController {
        let coordinator = DefaultDetailCoordinator(
            navigationController: navigationController,
            moduleFactory: coreAssembly.moduleFactory,
            detailAssembly: self
        )
        return coordinator.start(itemId: itemId)
    }
    
    func makeDetailViewModel(itemId: String) -> DetailViewModel {
        let remoteDataSource = DetailRemoteDataSource(apiService: coreAssembly.apiService)
        let localDataSource = DetailLocalDataSource(
            localStorage: coreAssembly.localStorage,
            sharedPreferences: SharedPreferences(localStorage: coreAssembly.localStorage)
        )
        let repository = DetailRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
        
        let getItemDetailUseCase = GetItemDetailUseCase(repository: repository)
        let getRelatedItemsUseCase = GetRelatedItemsUseCase(repository: repository)
        let toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: repository)
        let checkFavoriteStatusUseCase = CheckFavoriteStatusUseCase(repository: repository)
        
        return DetailViewModel(
            itemId: itemId,
            getItemDetailUseCase: getItemDetailUseCase,
            getRelatedItemsUseCase: getRelatedItemsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            checkFavoriteStatusUseCase: checkFavoriteStatusUseCase
        )
    }
}
