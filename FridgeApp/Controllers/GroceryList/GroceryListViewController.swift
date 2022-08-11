//
//  ProductListViewController.swift
//  FridgeApp
//
//  Created by Aayush Subedi
//

import UIKit
import DropDown //external library
//https://cocoapods.org/pods/DropDown


//class responsible for showing list of grocery items in a table view
class GroceryListViewController: UIViewController {
    
    //making it singleton
    static var instance: GroceryListViewController?
    
    
    public var items = [GroceryItem]()
    var menu = DropDown()
    
    var selectedCat = ""
    var selectedSort =  SortBy.expAsc
    
    
    @IBOutlet weak var lblCategory: UILabel!
    
    
    static private let kTableCellID = "ItemCellView"
    
    @IBOutlet weak var productTableView: UITableView!
    
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var dropDownView: UIView!
    
    override func viewDidLoad() {
        
        GroceryListViewController.instance = self
        
        super.viewDidLoad()
        
        GroceryListViewController.instance = self
        
        txtSearch.delegate = self
        
        refreshData()
        setupMenu()
        productTableView.delegate = self
        productTableView.dataSource = self
        
        productTableView.register(UITableViewCell.self,
                                  forCellReuseIdentifier: GroceryListViewController.kTableCellID)
        
        
        GroceryListViewController.instance = self
        
    }
    
    
    //setting up dropown options
    func setupMenu()  {
        
        var options = Constants.categories
        options.insert("All", at: 0)
        
        lblCategory.text = "Category: All"
        
        menu.dataSource = options
        menu.selectionAction = { (index: Int, item: String) in
            self.lblCategory.text = "Category: "+item
            
            self.selectedCat = index == 0 ? "" : item
            self.refreshData()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        dropDownView.addGestureRecognizer(tap)
        
        menu.anchorView = dropDownView
        
    }
    //call back for when dropdown is pressed
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        menu.show()
    }
    

    //makes call to database and updates the table view
    @objc  func refreshData(){
        self.items = DatabaseService.getAllGroceryItems(searchText: txtSearch.text ?? "", orderBy : selectedSort ,  category: selectedCat )
        productTableView.reloadData();
    }
    
    
    
    
    //methold to clear textbox and dissmiss on clear button tap
    @IBAction func onClearTap(_ sender: Any) {
        txtSearch.text = ""
        self.view.endEditing(true)
        self.refreshData()
    }
    
    

    //method called when sort button is tapped
    @IBAction func onSortTap(_ sender: Any) {
        
        //showing action sheet to let user select sort by
        let sortSelector = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        
        let expFirst = UIAlertAction(title: "Expiring First", style: .default) { (action) in
            self.selectedSort = SortBy.expAsc
            self.refreshData()
        }
        let expLast = UIAlertAction(title: "Expiring last", style: .default) { (action) in
            self.selectedSort = SortBy.expDsc
            self.refreshData()
        }
        
        let addedFirst = UIAlertAction(title: "Added First", style: .default) { (action) in
            self.selectedSort = SortBy.addedFirst
            self.refreshData()
        }
        
        let adedLast = UIAlertAction(title: "Added Last", style: .default) { (action) in
            self.selectedSort = SortBy.addedLast
            self.refreshData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        // Adding the actions to  actionSheet
        sortSelector.addAction(expFirst)
        sortSelector.addAction(expLast)
        sortSelector.addAction(addedFirst)
        sortSelector.addAction(adedLast)
        
        sortSelector.addAction(cancel)
        
        
        // Present the action sheet
        self.present(sortSelector, animated: true,completion: nil)
    }
    
    
    
}

//extension for the view to configure table view
extension GroceryListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "kItemDetailViewController") as? ItemDetailViewController {
            vc.item = selected
            present(vc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}

//extension for the view to configure table data source
extension GroceryListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    

    //handeling table cell swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            //deleting item from table and database after right swipe
            _ = DatabaseService.deleteGroceryItem(id: items[indexPath.row].id ?? 0)
          
            items.remove(at: indexPath.row)
            self.refreshData()
            
            //updating the summary view after data changed
            SummaryViewController.instance?.setupData()
            
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.productTableView.dequeueReusableCell(withIdentifier: "cell") as! ItemCellView
        cell.setupView(item: items[indexPath.row])
        return cell
    }
}


extension GroceryListViewController : UITextFieldDelegate {
    // Code to dismiss keyboard after return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.refreshData()
        return false
    }
}
