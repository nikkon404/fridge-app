//
//  ApiService.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation

class ApiService {
    
    ///[onSuccess] callback will be triggered if HTTP request and json data is parsed successfully
    ///
    ///[onError] callback will be triggered if any error occoures in the process
    
    static func fetchData(barCode: String,  onSuccess: @escaping (GroceryItem)-> Void, onError: @escaping (String) -> Void) {
        let url = Constants.apiUrl + barCode
        
        //Configuring http request
        let request = NSMutableURLRequest(url: NSURL(string:
                                                        url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        //creating http session session
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error!")
                return onError("\(String(describing: error))")
            }
            //continue if no error
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse==nil){
                return onError("http response is nil")
            }
            if(httpResponse!.statusCode == 200){
                do {
                    //decoding and parsing json data
                    let groceryItemModel = try JSONDecoder().decode(GroceryItemModel.self, from: data!)
                    print(groceryItemModel);
                    if(groceryItemModel.total>0)
                    {
                        var item = groceryItemModel.items.first!
                        
                        //clearing preloaded cateory that comes from the api
                        item.category = ""
                        return onSuccess(item)
                    }
                    
                }
                catch let parseErr {
                    print("failed to decode json:", parseErr)
                    return onError("Failed to parse fetched data")
                }
            }
            else if(httpResponse?.statusCode == 429)
            {
                //Http: Too many requests
                return onError("Please slow down..")
            }
            print(httpResponse!.statusCode)
            return onError("No product found for the given barcode")
            
        })
        //executing session
        dataTask.resume()
    }
}
