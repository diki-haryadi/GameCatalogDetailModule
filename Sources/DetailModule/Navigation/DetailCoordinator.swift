//
//  DetailCoordinator.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import UIKit
import SwiftUI
import CoreModule

public protocol DetailCoordinator {
    func start(itemId: String) -> UIViewController
    func navigateToDetail(itemId: String)
    func navigateToAuthor(authorId: String)
    func navigateToRelatedItem(itemId: String)
}

public class DefaultDetailCoordinator: DetailCoordinator {
    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol
    private let detailAssembly: DetailModuleAssembly
    
    public init(
        navigationController: UINavigationController,
        moduleFactory: ModuleFactoryProtocol,
        detailAssembly: DetailModuleAssembly
    ) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.detailAssembly = detailAssembly
    }
    
    public func start(itemId: String) -> UIViewController {
        let viewModel = detailAssembly.makeDetailViewModel(itemId: itemId)
        let detailView = DetailView(viewModel: viewModel, coordinator: self)
        let hostingController = UIHostingController(rootView: detailView)
        return hostingController
    }
    
    public func navigateToDetail(itemId: String) {
        guard let detailViewController = moduleFactory.makeDetailModule(itemId: itemId) else { return }
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    public func navigateToAuthor(authorId: String) {
        // This would be implemented when we have an Author module
        print("Navigate to author: \(authorId)")
    }
    
    public func navigateToRelatedItem(itemId: String) {
        navigateToDetail(itemId: itemId)
    }
}
