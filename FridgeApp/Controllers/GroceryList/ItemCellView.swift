//
//  ItemCellView.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 8/4/22.
//

import UIKit
class ItemCellView : UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var lblDays: UILabel!

    
    
    @IBOutlet weak var lblSubtite: UILabel!
    
    
    @IBOutlet weak var lblBottom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img?.layer.cornerRadius = (img?.frame.size.width ?? 0.0) / 2
        img?.clipsToBounds = true
        img?.layer.borderWidth = 1.8
        img?.layer.borderColor = UIColor.black.cgColor
    }
    
    
    public func setupView(item: GroceryItem){
        img?.image = Converter.base64StringToImage(imageBase64String:  item.base64Img ?? "")
        
        lblTitle?.text = item.title ?? ""
        lblSubtite?.text = item.category ?? ""
        
        let days = Converter.daysBetweenDates(endDate: item.expiryDate!)
        
        if(days <= 0)
        {
            self.contentView.backgroundColor =  UIColor.red.withAlphaComponent(0.3)
        }
        else{
            self.contentView.backgroundColor =  UIColor.white.withAlphaComponent(0.3)

        }
        
        lblDays?.text =  String(describing: days)
        
        lblBottom.text = item.brand
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
