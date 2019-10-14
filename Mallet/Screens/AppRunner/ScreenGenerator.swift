//
//  ScreenGenerator.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public protocol AppUI {
    func getUIData() -> UIData

    func reloadUI()
}

class AppButton: AppUIButton, AppUI {
    let onButtonClickID: Int

    override init(uiData: UIData) {

        let buttonData = uiData.buttonData ?? ButtonUIData()

        self.onButtonClickID = buttonData.code[.OnTap]?.funcID ?? -1

        super.init(uiData: uiData)

        self.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onButtonClick(_ sender: UIButton) {
        let appRunner = AppRunner.topAppRunner()

        DispatchQueue.global(qos: .default).async() {
            appRunner?.CallFunc(id: self.onButtonClickID)
        }
    }

    func getUIData() -> UIData {
        return self.uiData
    }

    func reloadUI() {
        self.uiData = uiData
        self.reload()
    }
}

class AppLabel: AppUILabel, AppUI {

    override init(uiData: UIData) {
        super.init(uiData: uiData)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getUIData() -> UIData {
        return self.uiData
    }

    func reloadUI() {
        self.reload()
    }
}

class AppTextField: AppUITextField, AppUI {

    override init(uiData: UIData) {
        super.init(uiData: uiData)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func getUIData() -> UIData {
        return self.uiData
    }

    func reloadUI() {
        self.reload()
    }
}


class AppSwitch: AppUISwitch, AppUI {

    override init(uiData: UIData) {
        super.init(uiData: uiData)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func getUIData() -> UIData {
        return self.uiData
    }

    func reloadUI() {
        self.reload()
    }
}

class AppSlider: AppUISlider, AppUI {

    override init(uiData: UIData) {
        super.init(uiData: uiData)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func getUIData() -> UIData {
        return self.uiData
    }

    func reloadUI() {
        self.reload()
    }
}

class AppTable: AppUITable, AppUI {

    override init(uiData: UIData) {
        super.init(uiData: uiData)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func getUIData() -> UIData {
        return self.uiData
    }

    func reloadUI() {
        self.reload()
    }
}

class ScreenGenerator {

    public func generateScreen(appRunner: AppRunner, inputUIData: [UIData], appView: UIView) {

        for uiData in inputUIData {
            var ui: UIView?
            switch uiData.uiType {
            case .Label:
                ui = AppLabel(uiData: uiData)

            case .Button:
                ui = AppButton(uiData: uiData)

            case .TextField:
                ui = AppTextField(uiData: uiData)

            case .Switch:
                ui = AppSwitch(uiData: uiData)

            case .Slider:
                ui = AppSlider(uiData: uiData)

            case .Table:
                ui = AppTable(uiData: uiData)
                break
            }

            if let ui = ui {
                appView.addSubview(ui)
            }

            if let appUI = ui as? AppUI {
                appRunner.appUI[uiData.uiID] = appUI
            }
        }
    }
}
