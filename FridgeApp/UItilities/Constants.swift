//
//  Constants.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation

///This class hold all constants that will be used throughout the application
class Constants{
    
    //"https://api.upcdatabase.org/product/068100046120?apikey=098f6bc22621d_demo_4de4e8326b4f6"
    //    https://api.upcitemdb.com/prod/trial/lookup?upc=066721002297
    
    
    static let apiUrl = "https://api.upcitemdb.com/prod/trial/lookup?upc="
    static let apIKey = "098f6bc22621d_demo_4de4e8326b4f6"
    
    static let defaultNotificationHour = 48;
    
    //for database
    static let databaseName = "fridgeApp.sqlite"
    static let groceryTable = "groceries"
    static let shoppingListTable = "shopping_list"
    
    static let categories = ["Vegetables", "Fruits", "Meat", "Dairy", "Grains", "Legumes", "Baked Goods", "Seafood", "Nuts and seeds", "Herbs and Spices", "Garnishes", "Others"]
    
    
    
    
}
