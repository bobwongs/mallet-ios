//
//  ScreenGenerator.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public protocol AppUI {
    var cloudVariableName: String? { get set }

    func getUIData() -> UIData

    func reloadUI()

    func updateTextWithCloudVariable(value: String)
}

class AppButton: AppUIButton, AppUI {

    var cloudVariableName: String?
    let onButtonClickID: Int

    override init(uiData: UIData) {

        let buttonData = uiData.buttonData ?? ButtonUIData()

        self.onButtonClickID = buttonData.onTap.funcID

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

    func updateTextWithCloudVariable(value: String) {
        self.uiData.buttonData?.text = value
        self.reloadUI()
    }
}

class AppLabel: AppUILabel, AppUI {

    var cloudVariableName: String?

    override init(uiData: UIData) {
        super.init(uiData: uiData)

        cloudVariableName = "label"
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

    func updateTextWithCloudVariable(value: String) {
        self.uiData.labelData?.text = value
        self.reloadUI()
    }
}

class AppTextField: AppUITextField, AppUI {

    var cloudVariableName: String?

    override init(uiData: UIData) {
        super.init(uiData: uiData)

        cloudVariableName = "textField"
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

    func updateTextWithCloudVariable(value: String) {

    }
}


class AppSwitch: AppUISwitch, AppUI {

    var cloudVariableName: String?

    override init(uiData: UIData) {
        super.init(uiData: uiData)

        cloudVariableName = "switch"
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

    func updateTextWithCloudVariable(value: String) {

    }
}

class AppSlider: AppUISlider, AppUI {

    var cloudVariableName: String?

    override init(uiData: UIData) {
        super.init(uiData: uiData)

        cloudVariableName = "slider"
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

    func updateTextWithCloudVariable(value: String) {

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
