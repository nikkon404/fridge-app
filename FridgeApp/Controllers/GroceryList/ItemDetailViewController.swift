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
    
    @IBOutlet weak var lblExp: UILabel!
    
    @IBOutlet weak var lblBrand: UILabel!

    
    @IBOutlet weak var lblAddedOn: UILabel!

       
    
    @IBOutlet weak var imgBar: UIImageView!
    
    var item = GroceryItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.image = Converter.base64StringToImage(imageBase64String: item.base64Img ?? "")
        lblTitle.text = item.title ?? ""
        lblDescription.text = item.description ?? ""
        lblCategory.text! += item.category ?? ""
        lblAddedOn.text! += item.dateAdded!.getFormattedDate() + "(\(Converter.daysBetweenDates(endDate: item.dateAdded!)) days ago)"
        
        
        
        let expDay = Converter.daysBetweenDates(endDate: item.expiryDate!)
        
        if(expDay < 0)
        {
            lblExp.text = "Expired \(0 - expDay) day(s) ago"
        }
        else if(expDay > 0)
        {
            lblExp.text = "Expires in \(expDay) day(s)"
        }
        else {
            lblExp.text = "Expires today"
        }
        lblExp.text! +=  " - " + item.expiryDate!.getFormattedDate()
        imgBar.image = Converter.generateBarcode(from: item.upc ?? "")
        lblBrand.text! += item.brand ?? ""

        // Do any additional setup after loading the view.
    }

}
