//
//  GroceryItem.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//



// To parse the JSON, add this file to your project and do:
//


import Foundation

//   let groceryItem = try? newJSONDecoder().decode(GroceryItem.self, from: jsonData)
// MARK: - GroceryItem
struct GroceryItem : Codable {
    let ean, title, groceryItemDescription, upc: String?
    let brand, model, color, size: String?
    let dimension, weight, category: String?
    let lowestRecordedPrice, highestRecordedPrice: Double?
    let images: [String]?
}

 struct GroceryItemModel:Codable{
 
    let total: Int
    let items : [GroceryItem]
}
