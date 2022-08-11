//
//  ShoppingListViewController.swift
//  FridgeApp
//
//  Created by user206611 on 7/25/22.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //array to store shopping list
    private var models = [ShoppingListItem]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //to get saved items in database after the app is relaunched
        getAllItems()

        //to add items
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
       
    }
    
    //to add items
    @objc private func didTapAdd(){
        
        let alert = UIAlertController(title: "New Item", message: "Enter new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            self?.createItem(name: text)
            }))
        present(alert, animated: true)
    }
    
    
    
    @IBAction func onShowMapTap(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapPage") as? MapViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //to get number of ShoppingList items
        return models.count
    }
//displaying data for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //current item in model is nth position
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    
  
    
    
    //to select row item
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        //creating alert
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //delete
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                
                guard let field = alert.textFields?.first, let newField = field.text, !newField.isEmpty else{
                    return
                }
                self?.updateItem(item: item, newName: newField)
                }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            
            self?.deleteItem(item: item)
        
        }))
        

        present(sheet, animated: true)
        
    }
    
    
    //coredatabase functions
    func getAllItems(){
        
        do{
            models = try context.fetch(ShoppingListItem.fetchRequest())
            
            //reloading data on main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }catch{
            // error handling
        }
    }
    

    
    
    func createItem(name: String){
        
        //creating new item
        let newItem = ShoppingListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        //saving to database
        do{
            try context.save()
            getAllItems()
            
        }catch{
            //error handling
        }
    }
    
    func deleteItem(item: ShoppingListItem){
        //deleting an item
        
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
            
        }catch{
            
        }
        
    }
    
    func updateItem(item: ShoppingListItem, newName: String){
        
        item.name = newName
        do{
            try context.save()
            getAllItems()
            
        }catch{
            
        }
            }



}
