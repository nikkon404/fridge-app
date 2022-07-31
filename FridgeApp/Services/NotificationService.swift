//
//  NotificationService.swift
//  FridgeApp
//
//  Created by Khushneet on 31/07/22.
//

import Foundation
import UserNotifications

class NotificationService: NSObject {
	static private(set) var authorized = false
	
	static func Authorize(with delegate: UNUserNotificationCenterDelegate) {
		let notifCenter = UNUserNotificationCenter.current()
		//Permission for request alert, soud and badge
		notifCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			NotificationService.authorized = granted
			if (granted) {
				notifCenter.delegate = delegate
			}
		}
	}
	
	static func register(for product:GroceryItem, before days:Int) {
		if (!NotificationService.authorized) {
			print("Not authorized")
			return
		}
		
		let notifContent = UNMutableNotificationContent()
		notifContent.title = NSString.localizedUserNotificationString(forKey: product.title ?? "", arguments: nil)
		notifContent.body = NSString.localizedUserNotificationString(forKey: "Grocery about to expire", arguments: nil)
		notifContent.sound = UNNotificationSound.default
		notifContent.badge = 1
		notifContent.userInfo = ["kProduct" : product]
	
		var dateInfo = Calendar.current.dateComponents([.year, .month, .day], from: product.expiryDate!)
		dateInfo.hour = 9 //Put your hour
		dateInfo.minute = 0 //Put your minutes

		//Receive notification after 5 sec
//		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
		let request = UNNotificationRequest(identifier: (String(describing: product.id)), content: notifContent, trigger: trigger)
		let center = UNUserNotificationCenter.current()
		
		center.add(request) { (error) in
			if let error = error {
				print("Error \(error.localizedDescription)")
			} else{
				print("send!!")
			}
		}
	}
}
