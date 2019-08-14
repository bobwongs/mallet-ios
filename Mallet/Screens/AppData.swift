//
//  AppData.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

class AppData: Codable {
    let appName: String
    let uiData: [UIData]
    let code: String

    init(appName: String, uiData: [UIData], code: String) {
        self.appName = appName
        self.uiData = uiData
        self.code = code
    }
}