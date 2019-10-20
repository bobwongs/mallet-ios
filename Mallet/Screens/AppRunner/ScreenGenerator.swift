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

    var onButtonClickID: Int?

    override init(uiData: UIData) {

        super.init(uiData: uiData)

        let buttonData = uiData.buttonData ?? ButtonUIData()

        if let funcID = buttonData.code[.OnTap]?.funcID {
            self.onButtonClickID = funcID
        }

        self.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onButtonClick(_ sender: UIButton) {
        guard let funcID = self.onButtonClickID else {
            return
        }

        let appRunner = AppRunner.topAppRunner()

        DispatchQueue.global(qos: .default).async() {
            appRunner?.CallFunc(id: funcID)
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

    var onTextFieldChangedID: Int?

    override init(uiData: UIData) {

        super.init(uiData: uiData)

        let textFieldData = uiData.textFieldData ?? TextFieldUIData()

        if let funcID = textFieldData.code[.OnChange]?.funcID {
            self.onTextFieldChangedID = funcID
        }

        self.addTarget(self, action: #selector(self.changeText(_:)), for: .allEditingEvents)
        self.addTarget(self, action: #selector(self.onTextFieldChanged(_:)), for: .editingDidEnd)
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

    @objc private func changeText(_ sender: UITextField) {
        self.uiData.textFieldData?.text = sender.text ?? ""
    }

    @objc private func onTextFieldChanged(_ sender: UITextField) {
        guard let funcID = self.onTextFieldChangedID else {
            return
        }

        DispatchQueue.global(qos: .default).async() {
            AppRunner.topAppRunner()?.CallFunc(id: funcID)
        }
    }
}


class AppSwitch: AppUISwitch, AppUI {

    var onSwitchChangedID: Int?

    override init(uiData: UIData) {
        super.init(uiData: uiData)

        let switchData = uiData.switchData ?? SwitchUIData()

        if let funcID = switchData.code[.OnChange]?.funcID {
            self.onSwitchChangedID = funcID
        }

        self.addTarget(self, action: #selector(self.onSwitchChanged(_:)), for: .valueChanged)
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

    @objc private func onSwitchChanged(_ sender: UISwitch) {
        guard let funcID = self.onSwitchChangedID else {
            return
        }

        DispatchQueue.global(qos: .default).async() {
            AppRunner.topAppRunner()?.CallFunc(id: funcID)
        }
    }
}

class AppSlider: AppUISlider, AppUI {

    var onSliderChangedID: Int?

    var onSliderStartedID: Int?

    var onSliderEndedID: Int?

    override init(uiData: UIData) {
        super.init(uiData: uiData)

        let sliderData = uiData.sliderData ?? SliderUIData()

        if let funcID = sliderData.code[.OnChange]?.funcID {
            self.onSliderChangedID = funcID
        }

        if let funcID = sliderData.code[.OnStart]?.funcID {
            self.onSliderStartedID = funcID
        }

        if let funcID = sliderData.code[.OnEnd]?.funcID {
            self.onSliderEndedID = funcID
        }

        self.addTarget(self, action: #selector(self.onSliderChanged(_:)), for: .valueChanged)
        self.addTarget(self, action: #selector(self.onSliderStarted(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self.onSliderEnded(_:)), for: .touchUpInside)
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

    @objc func onSliderChanged(_ sender: UISlider) {
        guard let funcID = self.onSliderChangedID else {
            return
        }

        DispatchQueue.global(qos: .default).async() {
            AppRunner.topAppRunner()?.CallFunc(id: funcID)
        }
    }


    @objc func onSliderStarted(_ sender: UISlider) {
        guard let funcID = self.onSliderStartedID else {
            return
        }

        DispatchQueue.global(qos: .default).async() {
            AppRunner.topAppRunner()?.CallFunc(id: funcID)
        }
    }


    @objc func onSliderEnded(_ sender: UISlider) {
        guard let funcID = self.onSliderEndedID else {
            return
        }

        DispatchQueue.global(qos: .default).async() {
            AppRunner.topAppRunner()?.CallFunc(id: funcID)
        }
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
