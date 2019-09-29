//
//  AppDelegate.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "run" {
            let storyboard = UIStoryboard(name: "AppRunner", bundle: nil)

            guard let appRunner = storyboard.instantiateInitialViewController() as? AppRunner else {
                fatalError()
            }

            guard let appID = Int(url.path.suffix(url.path.count - 1)) else {
                return true
            }

            appRunner.appData = StorageManager.getApp(appID: appID)

            self.window?.rootViewController = appRunner
        }

        if url.host == "i" {
            let storyboard = UIStoryboard(name: "AppRunner", bundle: nil)

            guard let appRunner = storyboard.instantiateInitialViewController() as? AppRunner else {
                fatalError()
            }

            let base64Str = String(url.path.suffix(url.path.count - 1))
            print(base64Str)
            appRunner.appData = StorageManager.decodeAppShortcutURL(base64Str: base64Str)

            print(appRunner.appData)

            self.window?.rootViewController = appRunner

        }

        self.window?.makeKeyAndVisible()

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


}

