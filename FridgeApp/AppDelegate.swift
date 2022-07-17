//
//  AppDelegate.swift
//  FridgeApp
//
//  Created by Khushneet on 10/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DatabaseService.initalize()
        
        
        
        //TEsting start
//        var x = GroceryItem(id: nil, ean: "123", upc: "123", dateAdded: "2022-02-11", title: "Title", category: Constants.categories.first!, expiryDate: "2022-06-06", groceryItemDescription: "Some desc", brand: "Brand", images: ["https://www.centurypublishing.com/wp-content/uploads/2013/02/Low-Resolution-Image.jpg"])
        
       // DatabaseService.insertGrocery(item:&x)

        
//
        
//        ApiService.fetchData(barCode: "066721002297") { (data) in
//            print(data)
//        } onError: { (err) in
//            print(err)
//        }
//
//        var res = DownloadService.onlineImageToBase64(imgUrl: "https://www.centurypublishing.com/wp-content/uploads/2013/02/Low-Resolution-Image.jpg")
        
        
        //Testing end

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


}

