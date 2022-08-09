//
//  ApiService.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation

class ApiService {
	
	static var result : DataFetchResult = .invalid
    
    
 ///method to perform api request to fetch grocery item by bar code
	static func fetchData(barCode: String,  completion : @escaping (DataFetchResult) -> Void) {
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
			if let err = error {
				print(err)
				result = .failure(error: err)
			}
			//continue if no error
			if let httpResponse = response as? HTTPURLResponse {
				if(httpResponse.statusCode == 200){
					do {
						//decoding and parsing json data
						let groceryItemModel = try JSONDecoder().decode(GroceryItemModel.self, from: data!)
						print(groceryItemModel);
						if(groceryItemModel.count > 0)
						{
							var item = groceryItemModel.getItem(at: 0)
							
							//clearing preloaded cateory that comes from the api
							item.category = ""
							result = .success(data: item)
						}
                        else{
                            result = .failure(error: NSError(domain: "No item found", code: 404, userInfo: nil))
                        }
					}
					catch let parseErr {
						print("failed to decode json:", parseErr)
						result = .failure(error: NSError(domain: "Json Parse Error", code: httpResponse.statusCode, userInfo: nil))
					}
				}
				else if(httpResponse.statusCode == 429)
				{
					//Http: Too many requests
					result = .failure(error: NSError(domain: "Please slow down", code: httpResponse.statusCode, userInfo: nil))
				}
				else{
					result = .failure(error: NSError(domain: "No item found", code: httpResponse.statusCode, userInfo: nil))
				}
			}
			completion(result)
		})
		//executing session
		dataTask.resume()
		
	}
}

enum DataFetchResult {
	case invalid
	case success(data: GroceryItem)
	case failure(error: Error)
}
