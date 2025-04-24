//
//  ItemDetailDTO.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

struct ItemDetailDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let content: String
    let imageUrl: String
    let author: AuthorDTO
    let category: String
    let tags: [String]
    let viewCount: Int
    let createdAt: String
    let updatedAt: String
    
    func toDomain() -> ItemDetail {
        return ItemDetail(
            id: id,
            title: title,
            description: description,
            content: content,
            imageUrl: imageUrl,
            author: author.toDomain(),
            category: category,
            tags: tags,
            viewCount: viewCount,
            createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date(),
            updatedAt: DateFormatter.iso8601.date(from: updatedAt) ?? Date()
        )
    }
}

struct AuthorDTO: Decodable {
    let id: String
    let name: String
    let avatarUrl: String?
    let bio: String?
    
    func toDomain() -> Author {
        return Author(
            id: id,
            name: name,
            avatarUrl: avatarUrl,
            bio: bio
        )
    }
}
