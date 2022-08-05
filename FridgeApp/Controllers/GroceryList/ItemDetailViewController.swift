//
//  ItemDetailViewController.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 8/5/22.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblAddedOn: UILabel!
       
    
    @IBOutlet weak var imgBar: UIImageView!
    
    var item = GroceryItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.image = Converter.base64StringToImage(imageBase64String: item.base64Img ?? "")
        lblTitle.text = item.title ?? ""
        lblDescription.text = item.description ?? ""
        lblCategory.text! += item.category ?? ""
        lblAddedOn.text = String(describing: item.dateAdded!)
        imgBar.image = Converter.generateBarcode(from: item.upc ?? "")

        // Do any additional setup after loading the view.
    }

}
