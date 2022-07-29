//
//  RootTabBarController.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//

import UIKit

class RootTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
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

