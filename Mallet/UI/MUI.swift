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

    var frameData: MUIFrame

    var backgroundData = MUIBackGround.disabled

    var textData = MUITextData.disabled

    static var none: MUI {
        MUI(uiID: -1, uiName: "", uiType: .space, frameData: MUIFrame(.zero))
    }

    static func defaultValue(type: MUIType) -> MUI {
        return MUI.defaultValue(uiID: 0, uiName: "", type: type, frame: .zero)
    }

    static func defaultValue(uiID: Int, uiName: String, type: MUIType, frame: MUIRect) -> MUI {

        var uiData = MUI(uiID: uiID, uiName: uiName, uiType: type, frameData: MUIFrame(frame))

        switch type {
        case .text:
            uiData.backgroundData = .defaultValue
            uiData.textData = .defaultValue
            break

        case .button:
            uiData.backgroundData = MUIBackGround(color: MUIColor(r: 0, g: 0, b: 255, a: 255), cornerRadius: 10)
            uiData.textData = MUITextData(text: "Button", color: .white, size: 17, alignment: .center)
            break

        case .toggle:
            uiData.frameData.lockWidth = true
            uiData.frameData.lockHeight = true
            break

        case .slider:
            uiData.frameData.lockHeight = true
            break

        case .input:
            uiData.frameData.lockHeight = true
            break

        default:
            break
        }

        return uiData
    }
}

struct MUIColor: Codable {

    var r: Int

    var g: Int

    var b: Int

    var a: Int

    static let clear = MUIColor(r: 0, g: 0, b: 0, a: 0)

    static let black = MUIColor(r: 0, g: 0, b: 0, a: 255)

    static let white = MUIColor(r: 255, g: 255, b: 255, a: 255)

    var toColor: Color {
        Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }

    var toUIColor: UIColor {
        UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

struct MUIFrame: Codable {

    var frame: MUIRect

    var lockHeight = false

    var lockWidth = false

    init(_ frame: MUIRect) {
        self.frame = frame
    }
}

struct MUIBackGround: Codable {

    var enabled = true

    var color: MUIColor

    var cornerRadius: CGFloat

    static let disabled = MUIBackGround(color: .clear, cornerRadius: 0)

    static let defaultValue = MUIBackGround(color: .clear, cornerRadius: 0)

}