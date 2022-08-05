//
//  DatabaseService.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation
import SQLite3

class DatabaseService {
	private static var db : OpaquePointer?
	
	///Initializer for database
	static func initalize() {
		db = databaseCreate()
		createGroceryTable()
		createShoppingTable()
	}
	
	///main method to create database
	private static func databaseCreate() -> OpaquePointer? {
		let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(Constants.databaseName)
		
		var db : OpaquePointer? = nil
		
		if sqlite3_open(filePath.path, &db) != SQLITE_OK {
			print("There is error in creating DB")
			return nil
		}else {
			print("Database has been created with path \(Constants.databaseName)")
			return db
		}
	}
	
	//method to create gorcey table
	private static func createGroceryTable(){
		let query = """
CREATE TABLE IF NOT EXISTS \(Constants.groceryTable) (
id INTEGER PRIMARY KEY,
ean TEXT,
upc Text,
dateAdded INTEGER,
title TEXT,
category TEXT,
expiryDate INTEGER,
notificationTime INTEGER,
description TEXT,
brand TEXT,
img, TEXT);
"""
		createTable(tableName:Constants.groceryTable, query: query)
		
	}
	
	//method to create shopping table
	private static func createShoppingTable() {
		let query = """
CREATE TABLE IF NOT EXISTS \(Constants.shoppingListTable) (
id INTEGER PRIMARY KEY,
title TEXT,
isChecked INTEGER);
"""
		createTable(tableName:Constants.shoppingListTable, query: query)
	}
	
	private static func createTable(tableName: String, query: String )  {
		
		var statement : OpaquePointer? = nil
		let res = sqlite3_prepare_v2(db, query, -1, &statement, nil)
		print(String(describing: res))
		if res == SQLITE_OK {
			if sqlite3_step(statement) == SQLITE_DONE {
				print(tableName + " Table creation success")
			}else {
				print(tableName + " Table creation fail")
			}
		} else {
			print(tableName + " Prepration fail")
		}
	}
	
	///Method to inset grocerty item to the database table
	static func insertGrocery(item: inout GroceryItem) -> Bool{
		var success = false
		let query = "INSERT INTO \(Constants.groceryTable) (ean, upc, dateAdded, title, category, expiryDate, notificationTime, description, brand, img) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
		
		var statement : OpaquePointer? = nil
		
		
		if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
			
			//binding values with ? placeholder in the query
			sqlite3_bind_text(statement, 1, (item.ean! as NSString).utf8String, -1, nil)
			sqlite3_bind_text(statement, 2, (item.upc! as NSString).utf8String, -1, nil)
            
            let dateAdded = Int(Date().timeIntervalSince1970)
            sqlite3_bind_int(statement, 3, Int32(dateAdded))
			
			sqlite3_bind_text(statement, 4, (item.title! as NSString).utf8String, -1, nil)
			sqlite3_bind_text(statement, 5, (item.category! as NSString).utf8String, -1, nil)
            
            let ExpDate = Int(item.expiryDate!.timeIntervalSince1970)
            sqlite3_bind_int(statement, 6, Int32(ExpDate))
            
            let notifDate = Int(item.expiryDate!.timeIntervalSince1970)
            sqlite3_bind_int(statement, 7, Int32(notifDate))
            
			sqlite3_bind_text(statement, 8, ((item.description ?? "" )as NSString).utf8String, -1, nil)
			sqlite3_bind_text(statement, 9, ((item.brand ?? "") as NSString).utf8String, -1, nil)
			sqlite3_bind_text(statement, 10, ((item.getRenderableImage() ?? "") as NSString).utf8String, -1, nil)
			
			if sqlite3_step(statement) == SQLITE_DONE {
				success = true
				print("Data inserted success")
			}else {
				print("Data is not inserted in table")
			}
		} else {
			print("Query is not as per requirement")
		}
		return success
		
	}
	
    static func getAllGroceryItems(searchText: String, orderBy: SortBy,  category: String) -> [GroceryItem]
	{
        let whereFilter: String = "title LIKE '%\(searchText)%'" + "AND category LIKE '%\(category)%'"
        
        
        let query = "SELECT * FROM \(Constants.groceryTable) WHERE \(whereFilter) ORDER BY \(orderBy.rawValue);"
        print(query)
		var queryStatement: OpaquePointer? = nil
		var data : [GroceryItem] = []
		if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
			while sqlite3_step(queryStatement) == SQLITE_ROW {
				//id, ean, upc, dateAdded, title, category, expiryDate, notificationTime, description, brand, img
				var item = GroceryItem()
				item.id = Int(sqlite3_column_int(queryStatement, 0))
				item.ean = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
				item.upc =  String(cString: sqlite3_column_text(queryStatement, 2))
                
                var raw = Int(sqlite3_column_int(queryStatement, 3))
                var date =  Date(timeIntervalSince1970: TimeInterval(raw))
                item.dateAdded = date
                
                
				item.title =  String(cString: sqlite3_column_text(queryStatement, 4))
				item.category =  String(cString: sqlite3_column_text(queryStatement, 5))
				
                 raw = Int(sqlite3_column_int(queryStatement, 6))
                 date =  Date(timeIntervalSince1970: TimeInterval(raw))
                item.expiryDate = date
                
                raw = Int(sqlite3_column_int(queryStatement, 7))
                 date =  Date(timeIntervalSince1970: TimeInterval(raw))
				item.notificationTime =    Date(timeIntervalSince1970: TimeInterval(raw))
                
				item.description =  String(cString: sqlite3_column_text(queryStatement, 8))
				item.brand =  String(cString: sqlite3_column_text(queryStatement, 9))
				let x = sqlite3_column_text(queryStatement, 10)
				item.base64Img = x == nil ? nil : String(cString: x!)
				
				data.append(item)
			}
		} else {
			print("SELECT statement could not be prepared")
		}
		sqlite3_finalize(queryStatement)
		return data
	}
	
	
	
	
	//delete methods
	
	static func deleteGroceryItem(id: Int) -> Bool{
		return deleteByID(id: id, tableName: Constants.groceryTable)
	}
	
	static func deleteShoppingItem(id: Int) -> Bool{
		return deleteByID(id: id, tableName: Constants.shoppingListTable)
	}
	
	
	private static func deleteByID(id:Int, tableName: String) -> Bool {
		var success = false;
		let query = "DELETE FROM \(tableName) WHERE Id = ?;"
		var deleteStatement: OpaquePointer? = nil
		if sqlite3_prepare_v2(db, query, -1, &deleteStatement, nil) == SQLITE_OK {
			sqlite3_bind_int(deleteStatement, 1, Int32(id))
			if sqlite3_step(deleteStatement) == SQLITE_DONE {
				print("Successfully deleted row.")
				success = true
			} else {
				print("Could not delete row.")
			}
		} else {
			print("DELETE statement could not be prepared")
		}
		sqlite3_finalize(deleteStatement)
		return success
	}
	
    private static func getDateFromString(_ val: String)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ss Z"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // Need to define TimeZone

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date =  dateFormatter.date(from: val)
        
        return date
        
    }
}
