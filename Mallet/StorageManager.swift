//
//  StorageManager.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

class StorageManager {
    static let userDefaults = UserDefaults.standard

    static private let appIDListKey = "AppIDList"

    static private let appNameKeyPrefix = "AppName_"

    static private let appDataPrefix = "AppData_"

    static func createNewApp() -> AppData {
        let appList = getAppList()
        let appID = appList.count
        let appName = "Untitled App"

        var appIDList = [Int]()
        for (appID, _) in appList {
            appIDList.append(appID)
        }
        appIDList.append(appID)

        userDefaults.set(appIDList, forKey: appIDListKey)
        userDefaults.set(appName, forKey: "\(appNameKeyPrefix)\(appID)")

        let appData = AppData(appName: appName, appID: appID, uiData: [], code: "")

        saveApp(appData: appData)

        return appData
    }

    static func saveApp(appData: AppData) {
        do {
            let jsonData = try JSONEncoder().encode(appData)
            let jsonStr = String(bytes: jsonData, encoding: .utf8)
            let fileName = "\(appDataPrefix)\(appData.appID).json"

            guard let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                return
            }

            let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent(fileName)

            do {
                try  jsonStr?.write(to: targetTextFilePath, atomically: true, encoding: .utf8)

                userDefaults.set(appData.appName, forKey: "\(appNameKeyPrefix)\(appData.appID)")
            } catch let error {
                print(error)
            }

        } catch let error {
            print(error)
        }
    }

    static func getApp(appID: Int) -> AppData {
        let jsonStr: String!

        guard let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return createNewApp()
        }

        let fileName = "\(appDataPrefix)\(appID).json"
        let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent(fileName)

        do {
            jsonStr = try String(contentsOf: targetTextFilePath, encoding: .utf8)
        } catch let error {
            print(error)
            return createNewApp()
        }

        guard let jsonData = jsonStr.data(using: .utf8) else {
            return createNewApp()
        }

        do {
            return try JSONDecoder().decode(AppData.self, from: jsonData)
        } catch let error {
            print(error)
            return createNewApp()
        }
    }


    static func getAppList() -> [(Int, String)] {
        var appList = [(Int, String)]()

        guard let appIDList = userDefaults.array(forKey: appIDListKey) as? [Int] else {
            return appList
        }

        for appID in appIDList {
            let appName = userDefaults.string(forKey: "\(appNameKeyPrefix)\(appID)") ?? "Untitled App"

            appList.append((appID, appName))
        }

        return appList
    }

    static func removeAll() {
        if let bundled = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundled)
        }

        guard let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryFileURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])

            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch let error {
            print(error)
        }
    }
}