//
//  AppDelegate.swift
//  FoodTalkPrivilege
//
//  Created by Ashish on 20/04/17.
//  Copyright © 2017 FoodTalkIndia. All rights reserved.
//

import UIKit
import Instamojo
import Parse
import Bolts
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "ftp"
            ParseMutableClientConfiguration.clientKey = "Al345ode2f"
            ParseMutableClientConfiguration.server = "http://52.74.136.146:1337/parse"
        })
        Parse.initialize(with: configuration)
        UIApplication.shared.applicationIconBadgeNumber = 0
        if(UserDefaults.standard.object(forKey: "session") == nil){
           
        }
        else{
            loginAs = "user"
            dictUserDetails = UserDefaults.standard.object(forKey: "userDetails") as! NSDictionary
            dictSessionInfo = UserDefaults.standard.object(forKey: "session") as! NSDictionary
            
            let userId = dictSessionInfo.object(forKey: "user_id") as! String
            let currentInstallation = PFInstallation.current()
            currentInstallation.setObject(userId, forKey: "userId")
            currentInstallation.saveInBackground()
            let storyBoard = self.window!.rootViewController!.storyboard;
            let nav = self.window!.rootViewController as! UINavigationController;
            let openPost = storyBoard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController;
            nav.visibleViewController!.navigationController!.pushViewController(openPost, animated:true);
        }
        
        
        
        let notificationType: UIUserNotificationType = [.alert, .sound]
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: notificationType, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
        
        let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
        let noPushPayload: AnyObject? = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as AnyObject?
        
        
        if oldPushHandlerOnly || noPushPayload != nil {
            PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        }
        
        FBSDKAppEvents.activateApp()
        Crashlytics.start(withAPIKey: "1dd9b3a281340dc23f1c672a7330fa1119c5a7b8")
        Fabric.with([Crashlytics.self])
        
        self.logUser()

        return true
    }
    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("ios@foodtalkindia.com")
        Crashlytics.sharedInstance().setUserIdentifier("iOS")
        Crashlytics.sharedInstance().setUserName("Foodtalk Privilege")
    }

    
    func popToRoot(_ sender : UIButton){
        let navigationController = UINavigationController()
        navigationController.popViewController(animated: true)
    }
    
    //MARK:- Push Notification Delegate Methods
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let currentInstallation = PFInstallation.current()
        currentInstallation.setDeviceTokenFrom(deviceToken)
        currentInstallation.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
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
        Instamojo.initialize()
        Instamojo.enableLog(option: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

