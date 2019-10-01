//
//  AppUIController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

@objcMembers
class AppUIController: NSObject {
    static func SetUIPositionX(id: Int, x: Double) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                uiData.x = CGFloat(x)

                ui.reloadUI()
            }
        }
    }

    static func SetUIPositionY(id: Int, y: Double) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                uiData.y = CGFloat(y)

                ui.reloadUI()
            }
        }
    }

    static func SetUIWidth(id: Int, width: Double) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                uiData.width = CGFloat(width)

                ui.reloadUI()
            }
        }
    }

    static func SetUIHeight(id: Int, height: Double) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                uiData.height = CGFloat(height)

                ui.reloadUI()
            }
        }
    }

    static func SetUIText(id: Int, text: String) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                switch uiData.uiType {
                case .Label:
                    uiData.labelData?.text = text

                case .Button:
                    uiData.buttonData?.text = text

                case .TextField:
                    uiData.textFieldData?.text = text

                default:
                    break
                }

                ui.reloadUI()
            }
        }
    }

    static func SetUIFontColor(id: Int, color: String) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                switch uiData.uiType {
                case .Label:
                    uiData.labelData?.fontColor = color

                case .Button:
                    uiData.buttonData?.fontColor = color

                case .TextField:
                    uiData.labelData?.fontColor = color

                default:
                    //TODO:
                    break
                }

                ui.reloadUI()
            }
        }
    }

    static func SetUIFontSize(id: Int, size: Int) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                switch uiData.uiType {
                case .Label:
                    uiData.labelData?.fontSize = size

                case .Button:
                    uiData.buttonData?.fontSize = size

                case .TextField:
                    uiData.labelData?.fontSize = size

                default:
                    //TODO:
                    break
                }

                ui.reloadUI()
            }
        }
    }

    static func SetUITextAlignment(id: Int, alignmentStr: String) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                let alignment: TextUIAlignment!
                switch alignmentStr {
                case "center":
                    alignment = .center
                case "left":
                    alignment = .left
                case "right":
                    alignment = .right
                default:
                    alignment = .left
                }

                switch uiData.uiType {
                case .Label:
                    uiData.labelData?.alignment = alignment

                case .TextField:
                    uiData.labelData?.alignment = alignment

                default:
                    //TODO:
                    break
                }

                ui.reloadUI()
            }
        }
    }

    static func SetUIBackgroundColor(id: Int, color: String) {
        DispatchQueue.main.async {
            let appRunner = AppRunner.topAppRunner()

            if let ui = appRunner?.appUI[id] {

                let uiData = ui.getUIData()

                switch uiData.uiType {
                case .Button:
                    uiData.buttonData?.backgroundColor = color

                default:
                    //TODO:
                    break
                }

                ui.reloadUI()
            }
        }
    }

}
