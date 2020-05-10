//
//  AppController.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class AppController {

    static let rootViewModel = RootViewModel()

    static func runApp(id: Int) {
        rootViewModel.runApp(id: id)
    }

    static func exitApp(id: Int) {
        rootViewModel.exitApp(id: id)
    }

    ///
    /// - Parameters:
    ///   - base64Str: encoded app data
    ///   - sync: wait until app is installed
    /// - Returns: app ID
    static func installApp(base64Str: String, sync: Bool = false) -> Int? {
        guard let data = Data(base64Encoded: base64Str) else {
            print("failed to install app")
            return nil
        }

        guard let appData = AppData.json2AppData(json: data) else {
            print("failed to install app")
            return nil
        }

        let appID = Storage.installApp(appData: appData, sync: sync).appID

        return appID
    }

}
