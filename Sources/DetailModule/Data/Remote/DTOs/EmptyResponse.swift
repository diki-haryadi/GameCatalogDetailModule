//
//  EmptyResponse.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

struct EmptyResponse: Decodable { }

// DetailModule/Sources/DetailModule/Domain/Models/ItemDetail.swift
import Foundation

public struct ItemDetail: Identifiable, Codable, Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let content: String
    public let imageUrl: String
    public let author: Author
    public let category: String
    public let tags: [String]
    public let viewCount: Int
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String,
        title: String,
        description: String,
        content: String,
        imageUrl: String,
        author: Author,
        category: String,
        tags: [String],
        viewCount: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.imageUrl = imageUrl
        self.author = author
        self.category = category
        self.tags = tags
        self.viewCount = viewCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
