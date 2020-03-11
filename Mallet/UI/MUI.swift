//
//  MUI.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/15.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUI: Codable {

    let uiID: Int

    let uiName: String

    let uiType: MUIType

    var frame: MRect

    var textData = MUITextData.disabled

    static var none: MUI {
        MUI(uiID: -1, uiName: "", uiType: .space, frame: MRect(x: 0, y: 0, width: 0, height: 0))
    }

    static func defaultValue(uiID: Int, uiName: String, type: MUIType, frame: MRect) -> MUI {

        var uiData = MUI(uiID: uiID, uiName: uiName, uiType: type, frame: frame)

        switch type {
        case .text:
            uiData.textData = .defaultValue
            break

        default:
            break
        }

        return uiData
    }
}

struct MUITextData: Codable {

    var enabled = true

    var text: String

    var color: MUIColor

    var size: CGFloat

    var alignment: MUITextAlignment

    static let disabled = MUITextData(enabled: false, text: "", color: .clear, size: 0, alignment: .center)

    static let defaultValue = MUITextData(enabled: true, text: "Label", color: .black, size: 17, alignment: .center)

}

enum MUITextAlignment: Int, Codable {

    case leading

    case center

    case trailing

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

struct MUIColor: Codable {

    var r: Int

    var g: Int

    var b: Int

    var a: Int

    static let clear = MUIColor(r: 0, g: 0, b: 0, a: 0)

    static let black = MUIColor(r: 0, g: 0, b: 0, a: 255)

    var toColor: Color {
        Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }

    var toUIColor: UIColor {
        UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

}

struct MUIFrame: Codable {

    var frame: MRect

    var lockHeight: Bool

    var lockWidth: Bool

}
