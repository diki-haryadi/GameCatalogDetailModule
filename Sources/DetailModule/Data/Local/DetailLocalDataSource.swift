//
//  DetailLocalDataSource.swift
//  GameCatalogMain
//
//  Created by ben on 23/04/25.
//

import Foundation
import CoreModule

public class DetailLocalDataSource {
    private let localStorage: LocalStorageProtocol
    private let sharedPreferences: SharedPreferences
    private let logger = Logger(category: "DetailLocalDataSource")
    
    // Keys
    private enum Keys {
        static func itemDetail(id: String) -> String { "item_detail_\(id)" }
        static func relatedItems(id: String) -> String { "related_items_\(id)" }
    }
    
    public init(localStorage: LocalStorageProtocol, sharedPreferences: SharedPreferences) {
        self.localStorage = localStorage
        self.sharedPreferences = sharedPreferences
    }
    
    func getItemDetail(id: String) throws -> ItemDetail? {
        return try localStorage.get(forKey: Keys.itemDetail(id: id))
    }
    
    func saveItemDetail(_ itemDetail: ItemDetail) throws {
        try localStorage.save(itemDetail, forKey: Keys.itemDetail(id: itemDetail.id))
    }
    
    func getRelatedItems(id: String) throws -> [RelatedItem]? {
        return try localStorage.get(forKey: Keys.relatedItems(id: id))
    }
    
    func saveRelatedItems(id: String, items: [RelatedItem]) throws {
        try localStorage.save(items, forKey: Keys.relatedItems(id: id))
    }
    
    func markAsFavorite(id: String) {
        sharedPreferences.addFavorite(id: id)
    }
    
    func unmarkAsFavorite(id: String) {
        sharedPreferences.removeFavorite(id: id)
    }
    
    func isFavorite(id: String) -> Bool {
        return sharedPreferences.isFavorite(id: id)
    }
}
