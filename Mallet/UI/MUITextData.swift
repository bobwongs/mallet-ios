//
//  MUITextData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/11.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import XyloSwift

struct MUITextData: Codable {

    var enabled = true

    var text: String

    var color: MUIColor

    var size: CGFloat

    var alignment: MUITextAlignment

    static let disabled = MUITextData(enabled: false, text: "", color: .clear, size: 0, alignment: .center)

    static let defaultValue = MUITextData(enabled: true, text: "Label", color: .black, size: 17, alignment: .center)

}

extension MUITextData: Equatable {

    public static func ==(lhs: MUITextData, rhs: MUITextData) -> Bool {
        lhs.enabled == rhs.enabled &&
            lhs.text == rhs.text &&
            lhs.color == rhs.color &&
            lhs.size == rhs.size &&
            lhs.alignment == rhs.alignment
    }

}

enum MUITextAlignment: Int, Codable {

    case leading

    case center

    case trailing

    var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var toTextAlignment: TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var toNSTextAlignment: NSTextAlignment {
        switch self {
        case .leading: return .left
        case .center: return .center
        case .trailing: return .right
        }
    }
}

protocol MUITextController {

    /// - Parameter args: [UIID, Text(String)]
    /// - Returns: .zero
    func setText(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Text(String)
    func getText(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Color(String, Hex Code)]
    /// - Returns: .zero
    func setTextColor(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Color(String, Hex Code)
    func getTextColor(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Size(Float)]
    /// - Returns: .zero
    func setTextSize(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Size(Float)
    func getTextSize(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID, Text(String)]
    /// - Returns: .zero
    func setTextAlignment(args: [XyObj]) -> XyObj

    /// - Parameter args: [UIID]
    /// - Returns: Text(String)
    func getTextAlignment(args: [XyObj]) -> XyObj

    var muiTextFuncs: [Xylo.Func] { get }

}
