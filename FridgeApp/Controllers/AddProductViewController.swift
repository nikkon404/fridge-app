//
//  AddProductViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 15/07/22.
//

import UIKit

class AddProductViewController: UIViewController {

	@IBOutlet weak var barcodeTextField: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    	
    // MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "kFetchSegueID" {
			if let next = segue.destination as? FetchProductViewController {
				if let barcodeNum = barcodeTextField.text {
					next.barcodeStr = barcodeNum
				}
			}
		}
	}


}
