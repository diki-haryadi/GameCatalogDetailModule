//
//  RelatedItemDTO.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation

struct RelatedItemDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let thumbnailUrl: String
    let category: String
    
    func toDomain() -> RelatedItem {
        return RelatedItem(
            id: id,
            title: title,
            description: description,
            thumbnailUrl: thumbnailUrl,
            category: category
        )
    }
}
