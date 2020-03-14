//
//  MUIToggleData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIToggleData: Codable {

    var enabled = true

    var value: Bool

    static let disabled = MUIToggleData(enabled: false, value: false)

    static let defaultValue = MUIToggleData(value: true)

}
