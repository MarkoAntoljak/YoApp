//
//  AppDelegate.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit
import FirebaseCore
import IQKeyboardManager
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    private let constants = Constants.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // setup firebase
        FirebaseApp.configure()
        // setup keyboard manager
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true
        keyboardManager.isEnableAutoToolbar = false
        
        // setup firebase notifications
        Messaging.messaging().delegate = self
         
        application.registerForRemoteNotifications()
        
        return true
    }

    // firebase
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        messaging.token { token, error in
            
            guard let token = token else {
                print("no token")
                return
            }
            
            print("token: \(token)")
        }
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        
    }

}

