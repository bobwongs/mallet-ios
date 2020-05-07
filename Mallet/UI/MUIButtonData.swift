//
//  MUIButtonData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIButtonData: Codable {

    var enabled = true

    static let disabled = MUIButtonData(enabled: false)

    static let defaultValue = MUIButtonData(enabled: true)

}


