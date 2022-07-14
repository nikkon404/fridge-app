//
//  ProductListViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//

import UIKit

class ProductListViewController: UIViewController {
	
	static private let kTableCellID = "kTableViewCell"
	
	@IBOutlet weak var productTableView: UITableView!
	private var productList : [Product] = Array<Product>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		productList.append(Product(name: "Test", barcodeNum: 123456789, price: 12.99))
		productList.append(Product(name: "Test 1", barcodeNum: 098765432, price: 1.99))
		productList.append(Product(name: "Test 2", barcodeNum: 456789876, price: 2.99))
		
		productTableView.delegate = self
		productTableView.dataSource = self
		
		productTableView.register(UITableViewCell.self,
										  forCellReuseIdentifier: ProductListViewController.kTableCellID)
	}
}

extension ProductListViewController : UITableViewDelegate {
	
}

extension ProductListViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		productList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: ProductListViewController.kTableCellID,
															  for: indexPath)
		cell.imageView?.image = UIImage(named: "Story")
		cell.textLabel?.text = productList[indexPath.row].name
		cell.detailTextLabel?.text = productList[indexPath.row].name
		return cell
	}
}
