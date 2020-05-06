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

protocol MUIToggleController {

    /// - Parameter args: [UIID, Value(Int)]
    /// - Returns: .zero
    /// 0;false, other:true
    func setValue(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Value(Int)
    /// true:1, false:0
    func getValue(args: [XyObj]) -> XyObj

}
