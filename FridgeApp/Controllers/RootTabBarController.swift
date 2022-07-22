//
//  RootTabBarController.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    func OnSuccess(item: GroceryItem)-> Void
    {
    
    }
    
    func onError(err: String)-> Void
    {
    
    }
    

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.        
       
    }

	override var shouldAutorotate: Bool {
		return false
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.portrait
	}
	
	override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return UIInterfaceOrientation.portrait
	}
}

