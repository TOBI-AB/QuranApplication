//
//  AppDelegate.swift
//  QuranApplication
//
//  Created by Abdelghaffar on 17/09/2015.
//  Copyright © 2015 Abdelghaffar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        // Setup TabBarController
        guard let window = self.window as UIWindow?, rootViewController = window.rootViewController as UIViewController? else {
            fatalError()
        }
        
        guard let tab = rootViewController as? UITabBarController, viewControllers = tab.viewControllers as [UIViewController]? else {
            fatalError()
        }
        
        
        guard let plistFilePath = NSBundle.mainBundle().pathForResource("TitlesTabBarItems", ofType: "plist"), titlesDictionary = NSDictionary(contentsOfFile: plistFilePath) as NSDictionary? else {
            fatalError()
        }

        // Get TabBarItem Title From Plist File
        viewControllers.forEach({ (viewController: UIViewController) -> () in
            guard let viewControllerIndex = viewControllers.indexOf(viewController) as Int? else {
                fatalError()
            }
            
            guard let titlesDictionary =  titlesDictionary["tab1"] as? Array<String>, titleTabBarItem = titlesDictionary[viewControllerIndex] as String? else {
                fatalError()
            }
            
            if let font = UIFont(name: "Arial", size: 15) {
                viewController.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
            }
            viewController.tabBarItem.title = titleTabBarItem
        })
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}













