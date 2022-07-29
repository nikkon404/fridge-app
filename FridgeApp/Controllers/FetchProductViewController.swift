//
//  FetchProductViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 22/07/22.
//

import UIKit

class FetchProductViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    public var barcodeStr :
        String = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            
            ApiService.fetchData(barCode: barcodeStr, completion: { result in
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        nameLabel.text = data.title
                    }
                    break
                default:
                    break
                }
            });
        }
	
}
