//
//  ProductListViewController.swift
//  FridgeApp
//
//  Created by Aayush Subedi
//

import UIKit
import DropDown


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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: Constants.onDataChanged), object: nil)
        
        GroceryListViewController.instance = self
        
    }
    
    
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
    
    @objc  func refreshData(){
        self.items = DatabaseService.getAllGroceryItems(searchText: txtSearch.text ?? "", orderBy : selectedSort ,  category: selectedCat )
        productTableView.reloadData();
    }
    
    
    
    
    @IBAction func onClearTap(_ sender: Any) {
        txtSearch.text = ""
        self.view.endEditing(true)
        self.refreshData()
    }
    
    
    @IBAction func onSortTap(_ sender: Any) {
        
        //showing action sheet to let user select sort by
        let imageSourceSelector = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        
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
        imageSourceSelector.addAction(expFirst)
        imageSourceSelector.addAction(expLast)
        imageSourceSelector.addAction(addedFirst)
        imageSourceSelector.addAction(adedLast)
        
        imageSourceSelector.addAction(cancel)
        
        
        // Present the action sheet
        self.present(imageSourceSelector, animated: true,completion: nil)
    }
    
    
    
}

extension GroceryListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = DatabaseService.deleteGroceryItem(id: items[indexPath.row].id ?? 0)
          
            items.remove(at: indexPath.row)
            self.refreshData()
            
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
