//
//  MUIFrameData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIFrameData: Codable {

    var frame: MUIRect

    var lockHeight = false

    var lockWidth = false

    init(_ frame: MUIRect) {
        self.frame = frame
    }
}