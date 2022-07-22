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
	private var productList : ProductList = ProductList()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		cell.imageView?.image = UIImage(named: "Sample")
		cell.textLabel?.text = productList.getProduct(at: indexPath.row).name
		cell.detailTextLabel?.text = productList.getProduct(at: indexPath.row).name
		
		return cell
	}
}
