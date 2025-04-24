//
//  Author.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//


import Foundation

public struct Author: Codable, Equatable {
    public let id: String
    public let name: String
    public let avatarUrl: String?
    public let bio: String?
    
    public init(
        id: String,
        name: String,
        avatarUrl: String?,
        bio: String?
    ) {
        self.id = id
        self.name = name
        self.avatarUrl = avatarUrl
        self.bio = bio
    }
}
