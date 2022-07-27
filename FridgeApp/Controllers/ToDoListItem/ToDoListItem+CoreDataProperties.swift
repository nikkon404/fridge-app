//
//  ToDoListItem+CoreDataProperties.swift
//  FridgeApp
//
//  Created by user206611 on 7/27/22.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    //to fetch data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }
//nsmanaged to access dtabase items
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItem : Identifiable {

}
