//
//  GroceryItem.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation

/// Entity for grocery item
// MARK: - GroceryItem
struct GroceryItem : Codable {
	//should not be changed once set
	var id: Int?
	var ean,upc: String?
	
	//variable that can be changed and updated
	var title,category: String?
	var dateAdded, expiryDate, notificationTime : Date?
	var description, brand: String?
	var images: [String]?
	var base64Img: String?
	
	
	///returns base64 version of the image
	mutating func getRenderableImage() ->  String? {
		if let image = base64Img {
			return image
		}
		
		if(images == nil || images?.count == 0 )  {
			return nil
		}
		
		base64Img = Converter.onlineImageToBase64(imgUrl: images?.first ?? "")
		return base64Img
	}
}

///Json model for grocery item

struct GroceryItemModel : Codable {
	private var items : [GroceryItem]
	
	var count : Int {
		items.count
	}
	
	func getItem(at index:Int) -> GroceryItem {
		return items[index]
	}
}
