//
//  RelatedItem.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

public struct RelatedItem: Identifiable, Codable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let thumbnailUrl: String
    public let category: String
    
    public init(
        id: String,
        title: String,
        description: String,
        thumbnailUrl: String,
        category: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.category = category
    }
}
