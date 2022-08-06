//
//  RootTabBarController.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//

import UIKit
import WARDoorView
class RootTabBarController: UITabBarController {
    
    @IBOutlet var haha: WARDoorView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
//        var customView = WARDoorView()
//        
//    
//        customView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 200)
//        customView.backgroundColor = UIColor.red     //give color to the view
//        customView.center = self.view.center
        let xPosition = self.view.frame.origin.x
        let yPosition = self.view.frame.origin.y - 20 // Slide Up - 20px
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        haha.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)

        self.view.addSubview(haha)

        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.haha.open(-90.0, duration: 1.3, delay: 0, completion:  {})
        }
        
        
    //self.view.addSubview( haha)
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

