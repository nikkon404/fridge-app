//
//  ShoppingListItem+CoreDataProperties.swift
//  FridgeApp
//
//  Created by Alimehdi Sajjadali Malpara on 7/27/22.
//
//

import Foundation
import CoreData


extension ShoppingListItem {

    //to fetch data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingListItem> {
        return NSFetchRequest<ShoppingListItem>(entityName: "ShoppingListItem")
    }
//nsmanaged to access dtabase items
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: String?


}

extension ShoppingListItem : Identifiable {

}
