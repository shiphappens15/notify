//
//  AppDelegate.swift
//  Notify
//
//  Created by Kevin Keating on 10/3/18.
//  Copyright © 2018 Kevin Keating. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        custom function to register, see below
        registerforPushNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func registerforPushNotifications() {
        let center = UNUserNotificationCenter.current()
        
//        can the user receive notifications?
        center.getNotificationSettings{ (settings) in
            
//            switch between the different stages
            switch settings.authorizationStatus {
                
//                user can receive pushes
                case .authorized:
                    print("Can receive pushes")
                
//                user denied pushes
                case .denied:
                    print("Alas, they said no")
                
//                user has not said yes or no
                case .notDetermined:
                    
//                    prepare an alert to inform the user - if they're using provisional alerts (iOS 12), this doesn't make sense!
                    let alert = UIAlertController.init(title: "Allow notifications", message: "To get the best experience with this app, allow alerts by clicking \"Allow\" on the next screen.", preferredStyle: .alert)
                    
//                    set up the confirm action (which will request authentication, if clicked)
                    let confirmAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
                        
//                        request the authorization
                        center.requestAuthorization(options: [.alert, .badge, .sound, .provisional]) {
                            (granted, error) in
                            
//                            if yes, or no
                            if granted {
                                print("User granted push authentication")
                            } else {
                                print("User denied push authentication or error")
                            }
                        }
                    }
                    
//                    set up the "cancel" action (which will dismiss the popup)
                    let cancelAction = UIAlertAction.init(title: "No, thanks", style: .cancel, handler: nil)
                    
//                    add the actions to the alert
                    alert.addAction(confirmAction)
                    alert.addAction(cancelAction)
                    
//                    confirm is the preferred action
                    alert.preferredAction = confirmAction
                    
//                    present the alert (we're in AppDelegate so present it this way)
                    self.window?.rootViewController?.present(alert, animated: true)
                
//                has provisionally accepted
            case .provisional:
                print("Provisionally accepted.")
                
//                default case (
                default:
                    print("idk")
            }
        }
    }
}

