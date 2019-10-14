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
    let appID: Int
    let uiData: [UIData]
    let bytecode: String
    let globalVariableCode: String

    init(appName: String, appID: Int, uiData: [UIData], bytecode: String, globalVariableCode: String) {
        self.appName = appName
        self.appID = appID
        self.uiData = uiData
        self.bytecode = bytecode
        self.globalVariableCode = globalVariableCode
    }
}
