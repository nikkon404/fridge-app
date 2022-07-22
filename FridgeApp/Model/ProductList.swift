//
//  ProductList.swift
//  FridgeApp
//
//  Created by Khushneet on 22/07/22.
//

import Foundation

struct ProductList {
	private var list : [Product] = Array<Product>()
	
	init() {
		addManuallyForTesting()
	}
	
	mutating func addManuallyForTesting() {
		list.append(Product(name: "Test", barcodeNum: 123456789, price: 12.99))
		list.append(Product(name: "Test 1", barcodeNum: 098765432, price: 1.99))
		list.append(Product(name: "Test 2", barcodeNum: 456789876, price: 2.99))
	}
	
	var count : Int {
		list.count
	}
	
	func getProduct(at index:Int) -> Product {
		return list[index]
	}
}
