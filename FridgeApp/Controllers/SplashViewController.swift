//
//  SplashViewController.swift
//  FridgeApp
//
//  Created by user206148 on 8/5/22.
//

import UIKit
import WARDoorView

class SplashViewController: UIViewController {
    @IBOutlet weak var warDoorView: WARDoorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        warDoorView.open()

        // Do any additional setup after loading the view.
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
