//
//  MUI.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/15.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUI: Codable {

    let uiID: Int

    let uiName: String

    let uiType: MUIType

    var frame: MRect

    static var none: MUI {
        MUI(uiID: -1, uiName: "", uiType: .space, frame: MRect(x: 0, y: 0, width: 0, height: 0))
    }
}
