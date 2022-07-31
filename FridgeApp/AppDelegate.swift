//
//  AppDelegate.swift
//  FridgeApp
//
//  Created by Aayush Subedi on 10/07/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		//Initializng database in the start of the application
		DatabaseService.initalize()
		NotificationService.Authorize(with: self)
		
		
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
		//                            description: "Some desc", brand: "Brand", images: ["https://www.centurypublishing.com/wp-content/uploads/2013/02/Low-Resolution-Image.jpg"])
		
		//        var data = DatabaseService.getAllGroceryItems()n
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
	
	// MARK: - Core Data stack
	//perscontain is database controller
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "FridgeApp")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	
}

