//
//  AppDelegate.swift
//  BreakTimeReminderApp
//
//  Created by HH on 21/08/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
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
    
    //MARK: - Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
         
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        for window in application.windows {
            window.rootViewController?.beginAppearanceTransition(false, animated: false)
            window.rootViewController?.endAppearanceTransition()
            
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        for window in application.windows {
            window.rootViewController?.beginAppearanceTransition(true, animated: false)
            window.rootViewController?.endAppearanceTransition()
        }
    }


}

