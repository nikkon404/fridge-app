//
//  ApiService.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 7/17/22.
//

import Foundation

class ApiService {
	
	static var result : DataFetchResult = .invalid    ///[onSuccess] callback will be triggered if HTTP request and json data is parsed successfully
	///
	///[onError] callback will be triggered if any error occoures in the process
	
	
	
	private static func getFakeData()-> GroceryItem? {
		let rawJson = """
	{
	        "code": "OK",
	        "total": 1,
	        "offset": 0,
	        "items": [
	            {
	                "ean": "0066721002297",
	                "title": "Ritz Low Sodium Crackers 200g/7oz Imported from Canada",
	                "description": "Ritz Low Sodium Crackers 200g/7oz Imported from Canada",
	                "upc": "066721002297",
	                "brand": "Ritz",
	                "model": "JH-0925-050",
	                "color": "",
	                "size": "",
	                "dimension": "",
	                "weight": "",
	                "category": "Home & Garden > Kitchen & Dining > Kitchen Tools & Utensils > Food Crackers",
	                "currency": "",
	                "lowest_recorded_price": 2.47,
	                "highest_recorded_price": 59.99,
	                "images": [
	                    "https://i5.walmartimages.com/asr/4359e82f-a980-4266-a757-5baee11774e8.fafcaa7dae69a47ed67fb7169dbb5c02.jpeg?odnHeight=450&odnWidth=450&odnBg=ffffff",
	                    "http://i5.walmartimages.ca/images/Large/359/108/1359108.jpg"
	                ],
	                "offers": [
	                    {
	                        "merchant": "Wal-Mart.com",
	                        "domain": "walmart.com",
	                        "title": "Ritz Low Sodium Crackers 200g/7oz Imported from Canada",
	                        "currency": "",
	                        "list_price": "",
	                        "price": 14.41,
	                        "shipping": "Free Shipping",
	                        "condition": "New",
	                        "availability": "",
	                        "link": "https://www.upcitemdb.com/norob/alink/?id=z2s253y2133384d4t2&tid=1&seq=1659125517&plt=c23e34ea263884c29d52342f0b62c49b",
	                        "updated_t": 1638987148
	                    },
	                    {
	                        "merchant": "WalMart Canada",
	                        "domain": "walmart.ca",
	                        "title": "Ritz Low Sodium Crackers",
	                        "currency": "CAD",
	                        "list_price": "",
	                        "price": 2.47,
	                        "shipping": "",
	                        "condition": "New",
	                        "availability": "",
	                        "link": "https://www.upcitemdb.com/norob/alink/?id=v2r213w2w2137454v2&tid=1&seq=1659125517&plt=dc728b96915aecacc6e361230a68fe09",
	                        "updated_t": 1559747495
	                    }
	                ],
	                "elid": "154565446908"
	            }
	        ]
	    }
	""".utf8
		
		do {
			let d = try JSONDecoder().decode(GroceryItemModel.self, from: Data(rawJson))
			return d.getItem(at: 0)
		} catch  {
			print("fail")
		}
		return nil
	}
	
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
