//
//  AppDelegate.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 10/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Initializng database in the start of the application
        DatabaseService.initalize()
        
        
        
        testing() //remove at production
        

		// Override point for customization after application launch.
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
    
    func testing(){
        
        
        //TEsting start
        
//        var x = GroceryItem(id: nil, ean: "060eam", upc: "0888upc", dateAdded: "2022-02-11", title: "Title", category: Constants.categories.first!, expiryDate: "2022-06-06",
//                            notificationTime: "2022-08-08",
//
//                            groceryItemDescription: "Some desc", brand: "Brand", images: ["https://www.centurypublishing.com/wp-content/uploads/2013/02/Low-Resolution-Image.jpg"])
        
//        var data = DatabaseService.getAllGroceryItems()
//        DatabaseService.insertGrocery(item:&x)
//        data = DatabaseService.getAllGroceryItems()
//        DatabaseService.deleteGroceryItem(id: 1)
//        data = DatabaseService.getAllGroceryItems()
//         print("hello")
//
        
//        ApiService.fetchData(barCode: "066721002297") { (data) in
//            print(data)
//        } onError: { (err) in
//            print(err)
//        }
//
//        var res = DownloadService.onlineImageToBase64(imgUrl: "https://www.centurypublishing.com/wp-content/uploads/2013/02/Low-Resolution-Image.jpg")
        
        
        //Testing end
        
    }


}

