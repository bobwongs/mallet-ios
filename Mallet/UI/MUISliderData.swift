//
//  MUISliderData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUISliderData: Codable {

    var enabled = true

    var value: Float

    var minValue: Float

    var maxValue: Float

    static let disabled = MUISliderData(value: 0, minValue: 0, maxValue: 0)

    static let defaultValue = MUISliderData(value: 0.5, minValue: 0, maxValue: 1)

}