//
//  Converter.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation
import UIKit


class Converter{
    //Author - user3763002
    //ref url - https://stackoverflow.com/questions/2782454/can-i-load-a-uiimage-from-a-url
    ///Method that converts imageurl to base64 string
    static func onlineImageToBase64(imgUrl: String) -> String?  {
        let url = NSURL(string: imgUrl);
        let imageData = try? NSData(contentsOf: url! as URL,options: NSData.ReadingOptions.mappedIfSafe)
        return imageData?.base64EncodedString();
    }
    
    ///Method that converts uiimage to base64 string
    static func imageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    ///Method that converts base64 string to UIImage
    static func base64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    
    //generate bar code image from string
    //src - https://developer.apple.com/forums/thread/77633
    static func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let output = filter.outputImage {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    ///get difference between dates in days -
    /// x days from now
    static func daysBetweenDates( endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: Date(), to: endDate)
        return components.day!
    }
}

