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
    
    @IBOutlet var door: WARDoorView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        //setting up door position
        let xPosition = self.view.frame.origin.x
        let yPosition = self.view.frame.origin.y 
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        door.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)

        self.view.addSubview(door)

        let seconds = 0.9
        
        //opening door after waiting for 0.9 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.door.open(-90.0, duration: 0.9, delay: 0, completion:  {})
        }
    }

    
    //forcefullt disableing rotation
	override var shouldAutorotate: Bool {
		return false
	}
	
    //forcefully setting orientation
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.portrait
	}
	
    //forcefully setting orientation
	override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		return UIInterfaceOrientation.portrait
	}
}

