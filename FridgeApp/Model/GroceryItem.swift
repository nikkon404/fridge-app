//
//  GroceryItem.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//



// To parse the JSON, add this file to your project and do:
//


import Foundation

// MARK: - GroceryItem
/// Entity for grocery item
struct GroceryItem : Codable {
    let ean, title, groceryItemDescription, upc: String?
    let brand, model, color, size: String?
    let dimension, weight, category: String?
    let lowestRecordedPrice, highestRecordedPrice: Double?
    let images: [String]?
}

///Json model for grocery item
 struct GroceryItemModel:Codable{
 
    let total: Int
    let items : [GroceryItem]
}
