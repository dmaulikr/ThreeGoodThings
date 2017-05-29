//
//  AppDelegate.swift
//  HappinessJournal
//
//  Created by Asher Dale on 12/12/16.
//  Copyright © 2016 Asher Dale. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var entryCon: EntryController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Sends the user to the EntryController when they open the app
        let tabBarController = self.window?.rootViewController as! UITabBarController
        tabBarController.tabBar.tintColor = User.sharedUser.color
        entryCon = tabBarController.customizableViewControllers?[2] as! EntryController!
        
        //entryCon.resetData()
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            User.sharedUser = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as! User
        } else {
            entryCon.shiftToIntro()
        }
        
        tabBarController.selectedIndex = 2
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Saves the user's data
        entryCon.saveData()
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
}
