//
//  FetchProductViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 22/07/22.
//

import UIKit

class FetchProductViewController: UIViewController {
	public var barcodeStr : String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		
		ApiService.fetchData(barCode: barcodeStr, completion: { result in
			
		});
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
