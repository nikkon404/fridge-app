//
//  ProductListViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//  Modified by Aayush Subedi
//

import UIKit

class GroceryListViewController: UIViewController {
    

    public var items = [GroceryItem]()
    
	
	static private let kTableCellID = "ItemCellView"
	
	@IBOutlet weak var productTableView: UITableView!
    
    
    @IBOutlet weak var txtSearch: UITextField!
    
    
	override func viewDidLoad() {
        
		super.viewDidLoad()
        txtSearch.delegate = self
        
        
        self.productTableView.register(ItemCellView.self, forCellReuseIdentifier: GroceryListViewController.kTableCellID)
        self.items = DatabaseService.getAllGroceryItems()

		
		productTableView.delegate = self
		productTableView.dataSource = self
		
		productTableView.register(UITableViewCell.self,
										  forCellReuseIdentifier: GroceryListViewController.kTableCellID)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: Constants.onDataChanged), object: nil)

	}
    
    @objc  func refreshData(searchText: String?){
        self.items = DatabaseService.getAllGroceryItems(searchText: searchText)
        productTableView.reloadData();
    }
}

extension GroceryListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        
        print(selected.dateAdded ?? "")
    
        //TODO: goto detail page
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "kItemDetailViewController") as? ItemDetailViewController {
            vc.item = selected
            present(vc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}

extension GroceryListViewController : UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
        let cell = self.productTableView.dequeueReusableCell(withIdentifier: "cell") as! ItemCellView
        
     
        cell.img?.image = Converter.base64StringToImage(imageBase64String:  items[indexPath.row].base64Img ?? "")
        
        cell.lblTitle?.text = items[indexPath.row].title ?? ""
        cell.lblSubtite?.text = items[indexPath.row].category ?? ""
        cell.lblBottom?.text =  "expires in " + String(describing: Converter.daysBetweenDates(endDate: items[indexPath.row].expiryDate!)) + " days"
      

        return cell
	}
}


extension GroceryListViewController : UITextFieldDelegate {
    // Code to dismiss keyboard after return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.refreshData(searchText: textField.text)
        return false
    }
}
