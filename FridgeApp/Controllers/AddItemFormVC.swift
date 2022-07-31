//
//  AddItemFormVC.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/29/22.
//

import UIKit

class AddItemFormVC: UIViewController {
	var item : GroceryItem?
	
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var categoryPicker: UIPickerView!
	@IBOutlet weak var expDatepicker: UIDatePicker!
	@IBOutlet weak var txtTitle: UITextField!
	@IBOutlet weak var txtDescription: UITextView!
	@IBOutlet weak var txtBrand: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		categoryPicker.dataSource = self
		categoryPicker.delegate = self
		
		//set data in textbox
		setupView()
	}
	
	@IBAction func onSavePressed(_ sender: Any) {
		if let err = valiDateInput() {
			let alert = UIAlertController(title: "Error", message: err, preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		else{
			//save and continue
		}
	}
	
	public func setupView()  {
		txtTitle.text = item?.title ?? ""
		txtDescription.text = item?.description ?? ""
		txtBrand.text = item?.brand ?? ""
		
		if let img = item?.getRenderableImage(){
			itemImage.image = Converter.convertBase64StringToImage(imageBase64String: img)
		}
		expDatepicker.minimumDate = Date()
		expDatepicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
	}
	
	@objc func datePickerChanged(picker: UIDatePicker) {
		item?.expiryDate = picker.date
		item?.notificationTime = ""
	}
	
	func valiDateInput() -> String? {
		var errorMsg: String?
		item?.title = txtTitle.text
		item?.description = txtDescription.text
		item?.brand =  txtBrand.text
		item?.category =  Constants.categories[ categoryPicker.selectedRow(inComponent: 0)]
		
		if(item?.expiryDate == nil ) {
			errorMsg = "Please select expiry date!"
		}
		
		return errorMsg
	}
}

extension AddItemFormVC : UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		// Row count: rows equals array length.
		return Constants.categories.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		// Return a string from the array for this row.
		return  Constants.categories[row]
	}
}
