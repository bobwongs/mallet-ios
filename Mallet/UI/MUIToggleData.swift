//
//  MUIToggleData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

struct MUIToggleData: Codable {

    var enabled = true

    var value: Bool

    static let disabled = MUIToggleData(enabled: false, value: false)

    static let defaultValue = MUIToggleData(value: true)

}

extension MUIToggleData: Equatable {

    public static func ==(lhs: MUIToggleData, rhs: MUIToggleData) -> Bool {
        lhs.enabled == rhs.value &&
            lhs.value == rhs.value
    }

}

protocol MUIToggleController {

    /// - Parameter args: [UIID, Value(Int or Float)]
    /// - Returns: .zero
    /// 0;false, other:true
    /// shared with MUISliderData
    func setValue(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Value(Int or Float)
    /// true:1, false:0
    /// shared with MUISliderData
    func getValue(args: [XyObj]) -> XyObj

    var muiToggleFuncs: [Xylo.Func] { get }

}
