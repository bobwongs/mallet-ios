//
//  AppDelegate.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

        addShortcuts(application: application)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        /*
        let appData: AppData!

        switch url.host {

        case "run":
            guard let appID = Int(url.path.suffix(url.path.count - 1)) else {
                return true
            }

            appData = AppDatabaseController.getApp(appID: appID)

        case "i":

            let base64Str = String(url.path.suffix(url.path.count - 1))
            print(base64Str)

            appData = AppDatabaseController.decodeAppShortcutURL(base64Str: base64Str)

            AppDatabaseController.createNewApp(appName: appData.appName, uiData: appData.uiData, bytecode: appData.bytecode, globalVariableCode: appData.globalVariableCode).appID

        default:
            return true

        }

        let storyboard = UIStoryboard(name: "AppRunner", bundle: nil)

        guard let appRunner = storyboard.instantiateInitialViewController() as? AppRunner else {
            fatalError()
        }

        appRunner.appData = appData

        let navigationController = UINavigationController(rootViewController: appRunner)

        navigationController.modalPresentationStyle = .fullScreen

        guard let topViewController = UIApplication.topViewController() else {
            return true
        }

        if let appRunner = topViewController as? AppRunner {
            if appData.appID == appRunner.appData?.appID {
                return true
            }
        }

        topViewController.modalPresentationStyle = .fullScreen

        topViewController.present(navigationController, animated: false)
        */

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

    func addShortcuts(application: UIApplication) {
        let createNewApp = UIMutableApplicationShortcutItem(type: "createNewApp",
                                                            localizedTitle: "Create New App",
                                                            localizedSubtitle: "",
                                                            icon: UIApplicationShortcutIcon(type: .add),
                                                            userInfo: nil)

        application.shortcutItems = [createNewApp]
    }

}

