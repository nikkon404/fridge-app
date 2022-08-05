//
//  ProductListViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//

import UIKit

class ProductListViewController: UIViewController {
    

    public var items = [GroceryItem]()
    
	
	static private let kTableCellID = "kTableViewCell"
	
	@IBOutlet weak var productTableView: UITableView!
 
    
	override func viewDidLoad() {
        
		super.viewDidLoad()
        self.items = DatabaseService.getAllGroceryItems()

		
		productTableView.delegate = self
		productTableView.dataSource = self
		
		productTableView.register(UITableViewCell.self,
										  forCellReuseIdentifier: ProductListViewController.kTableCellID)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: Constants.onDataChanged), object: nil)

	}
    
    @objc  func refreshData(){
        self.items = DatabaseService.getAllGroceryItems()
        productTableView.reloadData();
    }
}

extension ProductListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        
        print(selected.dateAdded ?? "")
    
        //TODO: goto detail page
    }
    
    
}

extension ProductListViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: ProductListViewController.kTableCellID,
															  for: indexPath)
        cell.imageView?.image = Converter.base64StringToImage(imageBase64String:  items[indexPath.row].base64Img ?? "")
        
        cell.textLabel?.text = items[indexPath.row].title ?? ""
 cell.detailTextLabel?.text = items[indexPath.row].description ?? ""
		
		return cell
	}
}
