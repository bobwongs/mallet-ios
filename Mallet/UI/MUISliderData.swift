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

    var value: CGFloat

    var minValue: CGFloat

    var maxValue: CGFloat

    static let disabled = MUISliderData(enabled: false, value: 0, minValue: 0, maxValue: 0)

    static let defaultValue = MUISliderData(value: 0.5, minValue: 0, maxValue: 1)

}
