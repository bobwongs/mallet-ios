//
//  AppData.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

class AppData: Codable {
    let uiData: [UIData]
    let code: String

    init(uiData: [UIData], code: String) {
        self.uiData = uiData
        self.code = code
    }
}