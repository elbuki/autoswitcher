//
//  AppDelegate.swift
//  AutoSwitcher
//
//  Created by Marco Carmona on 5/24/23.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {

    var model = HomeStore()
    
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
        
        let desiredState: Bool
        
        guard let action = userInfo["action"] as? String else {
            print("Could not parse the received action")
            completionHandler(.noData)
            return
        }
        
        if action == "charge" {
            desiredState = true
        } else if action == "discharge" {
            desiredState = false
        } else {
            print("Received unknown action: \(action)")
            completionHandler(.noData)
            return
        }
        
        Task {
            do {
                let storageManager = StorageManager()
                try await storageManager.load()
                
                if let outlet = storageManager.outlet {
                    try await model.setPowerState(
                        for: outlet.characteristicIdentifier,
                        to: desiredState
                    )
                }
                
                completionHandler(.newData)
            } catch {
                print(error.localizedDescription)
                completionHandler(.failed)
            }
        }
        
    }

    
}


