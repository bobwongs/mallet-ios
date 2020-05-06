//
//  MUISliderData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

struct MUISliderData: Codable {

    var enabled = true

    var value: CGFloat

    var minValue: CGFloat

    var maxValue: CGFloat

    static let disabled = MUISliderData(enabled: false, value: 0, minValue: 0, maxValue: 0)

    static let defaultValue = MUISliderData(value: 0.5, minValue: 0, maxValue: 1)

}

protocol MUISliderController {

    // Implemented in MUIToggleData
    // func setValue(args: [XyObj]) -> XyObj

    // Implemented in MUIToggleData
    // func getValue(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, MinValue(Float)]
    /// - Returns: .zero
    func setMinValue(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Value(MinFloat)
    func getMinValue(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, MaxValue(Float)]
    /// - Returns: .zero
    func setMaxValue(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: MaxValue(Float)
    func getMaxValue(args: [XyObj]) -> XyObj

    var muiSliderFuncs: [Xylo.Func] { get }

}
