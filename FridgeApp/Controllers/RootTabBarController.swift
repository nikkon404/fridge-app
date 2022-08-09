//
//  RootTabBarController.swift
//  FridgeApp
// Created by Khushneet
//  Modified by Aayush Subedi
//

import UIKit
import WARDoorView



// class to control parent tab view
class RootTabBarController: UITabBarController {
    
    @IBOutlet var haha: WARDoorView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        let xPosition = self.view.frame.origin.x
        let yPosition = self.view.frame.origin.y 
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        haha.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)

        self.view.addSubview(haha)

        let seconds = 0.6
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.haha.open(-90.0, duration: 0.6, delay: 0, completion:  {})
        }
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

