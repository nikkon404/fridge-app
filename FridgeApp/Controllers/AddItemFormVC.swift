//
//  AddItemFormVC.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/29/22.
//

import UIKit

class AddItemFormVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // Row count: rows equals array length.
        return Constants.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        return  Constants.categories[row]
    }

    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
     var item : GroceryItem?
    
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtDescription: UITextView!
  
    @IBOutlet weak var txtBrand: UITextField!
    
    public func setupView()  {
        txtTitle.text = item?.title ?? ""
        txtDescription.text = item?.description ?? ""
        txtBrand.text = item?.brand ?? ""
    }
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        //set data in textbox
        setupView()
        
    }

}
