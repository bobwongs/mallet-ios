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

    var value: Float

    var minValue: Float

    var maxValue: Float

    var step: Float?

    var onChanged = MUIAction(name: "onChanged", args: [], code: "")

    var onEnded = MUIAction(name: "onEnded", args: [], code: "")

    static let disabled = MUISliderData(enabled: false, value: 0, minValue: 0, maxValue: 0, step: nil)

    static let defaultValue = MUISliderData(value: 5, minValue: 0, maxValue: 10, step: nil)

}

extension MUISliderData: Equatable {

    public static func ==(lhs: MUISliderData, rhs: MUISliderData) -> Bool {
        lhs.enabled == rhs.enabled &&
            lhs.value == rhs.value &&
            lhs.minValue == rhs.minValue &&
            lhs.maxValue == rhs.maxValue &&
            lhs.step == rhs.step
    }

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

    /// - Parameter args: [UIID, Step(Float)]
    /// - Returns: .zero
    func setStep(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Step(Float)
    func getStep(args: [XyObj]) -> XyObj

    var muiSliderFuncs: [Xylo.Func] { get }

}
