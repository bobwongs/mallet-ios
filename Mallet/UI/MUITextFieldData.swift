//
//  MUITextFieldData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

struct MUITextFieldData: Codable {

    var enabled = true

    var text: String

    var placeholder: String

    var color: MUIColor

    var size: CGFloat

    var alignment: MUITextAlignment

    static let disabled = MUITextFieldData(enabled: false, text: "", placeholder: "", color: .clear, size: 0, alignment: .center)

    static let defaulValue = MUITextFieldData(text: "", placeholder: "Text", color: .black, size: 17, alignment: .leading)

}

protocol MUITextFieldController {

    // Implemented in MUITextController
    // func setText(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func getText(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Text(String)]
    /// - Returns: .zero
    func setPlaceHolder(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Text(String)
    func getPlaceHolder(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func setTextColor(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func getTextColor(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func setTextSize(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func getTextSize(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func setTextAlignment(args: [XyObj]) -> XyObj

    // Implemented in MUITextController
    // func getTextAlignment(args: [XyObj]) -> XyObj

}
