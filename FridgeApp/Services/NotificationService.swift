//
//  NotificationService.swift
//  FridgeApp
//
//  Created by Khushneet on 31/07/22.
//  Updated by Aayush Subedi
//

import Foundation
import UserNotifications

class NotificationService: NSObject {
	static private(set) var authorized = false
	
    //initializ notification service and ask for permission
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
	
    
    //schedule notification for the given GroceryItem
    static func register(item: GroceryItem) {
		if (!NotificationService.authorized) {
			print("Not authorized")
			return
		}
        let content = UNMutableNotificationContent()
        content.title =  item.title ?? ""
        content.subtitle = "Grocery is going to expire!"
        content.sound = UNNotificationSound.default
        
        // show this notification 10 seconds from now
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: item.notificationTime!.timeIntervalSinceNow, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add the  request
        UNUserNotificationCenter.current().add(request)
        return
    }

}
