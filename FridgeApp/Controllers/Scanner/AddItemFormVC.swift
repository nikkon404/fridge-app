//
//  AddItemFormVC.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/29/22.
//

import UIKit

class AddItemFormVC: UIViewController{
	var item : GroceryItem?
    

	
	@IBOutlet weak var itemImage: UIImageView!
	@IBOutlet weak var categoryPicker: UIPickerView!
	@IBOutlet weak var expDatepicker: UIDatePicker!
    @IBOutlet weak var reminderDateTimePicker: UIDatePicker!
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
    
    func showAlert(_ title: String,_ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
	
	@IBAction func onSavePressed(_ sender: Any) {
		if let err = valiDateInput() {
            showAlert("Error",err)
		}
		else{
            
            //test code to set expiry date 7 days ago
           // item?.expiryDate  = DCalendar.current.date(byAdding: .day, value: -7, to: Date())

            let success =  DatabaseService.insertGrocery(item: &item!)
            if(success)
            {
                NotificationService.register(item:  item!)
                self.dismiss(animated: true, completion: nil)
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.popToRootViewController(animated: true)
                showAlert("Info","Item added successfully!")
                
                
                GroceryListViewController.instance.refreshData()
                

              //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.onDataChanged), object: nil)

                print("success")
                
            }
            else{
                showAlert("Error","Failed to save grocery item")

            }
		}
	}
	
	public func setupView()  {
        reminderDateTimePicker.minimumDate = Date()
        expDatepicker.minimumDate = Date()

		txtTitle.text = item?.title ?? ""
		txtDescription.text = item?.description ?? ""
		txtBrand.text = item?.brand ?? ""
		
		if let img = item?.getRenderableImage(){
			itemImage.image = Converter.base64StringToImage(imageBase64String: img)
		}
		expDatepicker.addTarget(self, action: #selector(expdatePickerChanged(picker:)), for: .valueChanged)
        reminderDateTimePicker.addTarget(self, action: #selector(reminderTimeChanged(picker:)), for: .valueChanged)

	}
	
    ///callback for expiry date picker chaned
	@objc func expdatePickerChanged(picker: UIDatePicker) {
		item?.expiryDate = picker.date
        
        //resetting val of reminder everytime
        reminderDateTimePicker.maximumDate = picker.date
        
        //subtracting  X hours in selected expiry date to set reminder notification date
        let defaultHoursEarly = Calendar.current.date(byAdding: .hour, value: -Constants.defaultNotificationHour, to: picker.date)!

        reminderDateTimePicker.date = defaultHoursEarly
        item?.notificationTime = defaultHoursEarly
	}
    
    ///callback for expiry date picker chaned
    @objc func reminderTimeChanged(picker: UIDatePicker) {
        item?.notificationTime = picker.date
    }
	
	func valiDateInput() -> String? {
		item?.title = txtTitle.text
		item?.description = txtDescription.text
		item?.brand =  txtBrand.text
		item?.category =  Constants.categories[ categoryPicker.selectedRow(inComponent: 0)]
        item?.base64Img =  Converter.imageToBase64String(img:  itemImage.image!)
        
        if (item?.title ?? "") == "" {
            return "Please enter title"
        }
		
		if(item?.expiryDate == nil ) {
			return "Please select expiry date!"
		}
        
        else if(item?.notificationTime == nil ) {
            return "Please set reminder date - time!"
        }
		return nil
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




///extension for picking and handeling images functions
extension AddItemFormVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBAction func onPickImage(_ sender: Any) {
        
        //showing action sheet to let user pick image from the gallery or camera
        let imageSourceSelector = UIAlertController(title: nil, message: nil, preferredStyle:.actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.proceedPickImage(source: .camera)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.proceedPickImage(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        // Adding the actions to  actionSheet
        imageSourceSelector.addAction(camera)
        imageSourceSelector.addAction(gallery)
        imageSourceSelector.addAction(cancel)
        
        // Present the action sheet
        self.present(imageSourceSelector, animated: true,completion: nil)
        
    }
    
    ///begins to select image from the given image source
    func proceedPickImage(source: UIImagePickerController.SourceType)  {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = source
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)    }
    
    
    ///handler when image is done picking from the image source
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.itemImage.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {}
}

