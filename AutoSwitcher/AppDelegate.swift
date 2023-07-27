//
//  AppDelegate.swift
//  AutoSwitcher
//
//  Created by Marco Carmona on 5/24/23.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if error != nil {
                dump(error)
                return
            }
            
            if !granted {
                print("not granted")
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        return true
        
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        
        let reduced = deviceToken.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
        
        print("hexed token: \(reduced)")
        
        // TODO: Set up this token in the app and begin testing
        // F5A2BBB7F5841D7FA506BAFA40BDBAE2CD2BC40B3A4D1F99CD977B128F3C3E22
        
        // TODO: Send the token to a server somehow
        // https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        
        dump(error)
        fatalError("could not register for remote notifications")
        
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        
        print("received notification")
        
        completionHandler(.newData)
        
    }

    
}


