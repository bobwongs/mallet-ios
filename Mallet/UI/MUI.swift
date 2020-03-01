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
}
