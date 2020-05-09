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

    var uiName: String

    let uiType: MUIType

    var frameData: MUIFrameData

    var backgroundData = MUIBackgroundData.disabled

    var buttonData = MUIButtonData.disabled

    var textData = MUITextData.disabled

    var textFieldData = MUITextFieldData.disabled

    var sliderData = MUISliderData.disabled

    var toggleData = MUIToggleData.disabled

    static var none: MUI {
        MUI(uiID: -1, uiName: "", uiType: .space, frameData: MUIFrameData(.zero))
    }

    static func defaultValue(type: MUIType) -> MUI {
        MUI.defaultValue(uiID: 0, uiName: "", type: type, frame: .zero)
    }

    static func defaultValue(uiID: Int, uiName: String, type: MUIType, frame: MUIRect) -> MUI {

        var uiData = MUI(uiID: uiID, uiName: uiName, uiType: type, frameData: MUIFrameData(frame))

        switch type {
        case .text:
            uiData.backgroundData = .defaultValue
            uiData.textData = .defaultValue
            break

        case .button:
            uiData.backgroundData = MUIBackgroundData(color: MUIColor(r: 0, g: 122, b: 255), cornerRadius: 10)
            uiData.buttonData = .defaultValue
            uiData.textData = MUITextData(text: "Button", color: .white, size: 17, alignment: .center)
            break

        case .textField:
            uiData.frameData.lockHeight = true
            uiData.textFieldData = .defaultValue
            uiData.backgroundData = .disabled
            break

        case .slider:
            uiData.frameData.lockHeight = true
            uiData.backgroundData = .disabled
            uiData.sliderData = .defaultValue
            break

        case .toggle:
            uiData.frameData.lockWidth = true
            uiData.frameData.lockHeight = true
            uiData.backgroundData = .disabled
            uiData.toggleData = .defaultValue
            break

        default:
            break
        }

        return uiData
    }

    static func copyUIData(uiData: MUI, uiID: Int, uiName: String) -> MUI {
        var newUIData = MUI(uiID: uiID, uiName: uiName, uiType: uiData.uiType, frameData: uiData.frameData)
        newUIData.backgroundData = uiData.backgroundData
        newUIData.buttonData = uiData.buttonData
        newUIData.textData = uiData.textData
        newUIData.textFieldData = uiData.textFieldData
        newUIData.sliderData = uiData.sliderData
        newUIData.toggleData = uiData.toggleData

        return newUIData
    }
}

extension MUI {

    static func putView(uiData: Binding<MUI>) -> some View {
        generateView(uiData: uiData)
            .position(x: uiData.wrappedValue.frameData.frame.midX,
                      y: uiData.wrappedValue.frameData.frame.midY)
    }

    static func generateView(uiData: Binding<MUI>) -> some View {

        let type = uiData.wrappedValue.uiType

        let frameData = uiData.wrappedValue.frameData

        let backgroundData = uiData.wrappedValue.backgroundData

        let view = Group {
            if type == .text {
                MUIText(uiData: uiData)
            } else if type == .button {
                MUIButton(uiData: uiData)
            } else if type == .textField {
                MUITextField(uiData: uiData)
            } else if type == .slider {
                MUISlider(uiData: uiData)
            } else if type == .toggle {
                MUIToggle(uiData: uiData)
            } else {
                MUISpace()
            }
        }

        let viewWithFrame = Group {
            if frameData.lockWidth && frameData.lockHeight {
                view
            } else if frameData.lockWidth {
                view
                    .frame(height: frameData.frame.height)
            } else if frameData.lockHeight {
                view
                    .frame(width: frameData.frame.width)
            } else {
                view
                    .frame(width: frameData.frame.width, height: frameData.frame.height)
            }
        }
            .background(backgroundData.color.color)

        return Group {
            if backgroundData.cornerRadius == 0 {
                viewWithFrame
            } else {
                viewWithFrame
                    .cornerRadius(backgroundData.cornerRadius)
            }
        }
    }

}

extension MUI {

    func getCode() -> [Binding<MUIAction>] {
        var codes = [Binding<MUIAction>]()

        if buttonData.enabled {
            codes.append(
                Binding(
                    get: { self.buttonData.onTapped },
                    set: { _ in }
                )
            )
        }

        return codes
    }

    static func getCode(from ui: Binding<MUI>) -> [Binding<MUIAction>] {
        var codes = [Binding<MUIAction>]()

        if ui.buttonData.enabled.wrappedValue {
            codes.append(ui.buttonData.onTapped)
        }

        return codes
    }

}
