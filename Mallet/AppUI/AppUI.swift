//
//  AppUI.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/06.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public enum UIType: Int, Codable, CaseIterable {
    case Label
    case Button
    case TextField
    case Switch
    case Slider
}

public class AppUILabel: UILabel {
    let uiData: UIData

    init(uiData: UIData) {
        self.uiData = uiData

        super.init(frame: CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height))

        let labelData = uiData.labelData ?? LabelUIData()

        self.text = labelData.text
        self.textColor = UIColor(hex: labelData.fontColor)
        self.font = self.font.withSize(CGFloat(labelData.fontSize))
        self.textAlignment = UIData.TextUIAlignment2NSTextAlignment(alignment: labelData.alignment)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        let labelData = uiData.labelData ?? LabelUIData()

        self.text = labelData.text
        self.textColor = UIColor(hex: labelData.fontColor)
        self.font = self.font.withSize(CGFloat(labelData.fontSize))
        self.textAlignment = UIData.TextUIAlignment2NSTextAlignment(alignment: labelData.alignment)
    }
}

public class AppUIButton: UIButton {
    let uiData: UIData

    init(uiData: UIData) {
        self.uiData = uiData

        super.init(frame: CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height))

        let buttonData = uiData.buttonData ?? ButtonUIData()

        self.backgroundColor = UIColor(hex: buttonData.backgroundColor)
        self.setTitle(buttonData.text, for: .normal)
        self.setTitleColor(UIColor(hex: buttonData.fontColor), for: .normal)
        self.titleLabel?.font = self.titleLabel?.font.withSize(CGFloat(buttonData.fontSize))
        self.setTitleColor(UIColor(hex: buttonData.fontColor, alpha: 0.8), for: .highlighted)
        self.layer.cornerRadius = 7
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        let buttonData = uiData.buttonData ?? ButtonUIData()

        self.backgroundColor = UIColor(hex: buttonData.backgroundColor)
        self.setTitle(buttonData.text, for: .normal)
        self.setTitleColor(UIColor(hex: buttonData.fontColor), for: .normal)
        self.titleLabel?.font = self.titleLabel?.font.withSize(CGFloat(buttonData.fontSize))
        self.setTitleColor(UIColor(hex: buttonData.fontColor, alpha: 0.8), for: .highlighted)
        self.layer.cornerRadius = 7
    }

}

public class AppUITextField: UITextField {
    let uiData: UIData

    init(uiData: UIData) {
        self.uiData = uiData

        super.init(frame: CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height))

        let textFieldData = uiData.textFieldData ?? TextFieldUIData()

        self.text = textFieldData.text
        self.textColor = UIColor(hex: textFieldData.fontColor)
        self.font = self.font?.withSize(CGFloat(textFieldData.fontSize))
        self.textAlignment = UIData.TextUIAlignment2NSTextAlignment(alignment: textFieldData.alignment)

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }

        self.borderStyle = .roundedRect
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    func reload() {
        let textFieldData = uiData.textFieldData ?? TextFieldUIData()

        self.text = textFieldData.text
        self.textColor = UIColor(hex: textFieldData.fontColor)
        self.font = self.font?.withSize(CGFloat(textFieldData.fontSize))
        self.textAlignment = UIData.TextUIAlignment2NSTextAlignment(alignment: textFieldData.alignment)
    }
}

public class AppUISwitch: UISwitch {
    let uiData: UIData

    init(uiData: UIData) {
        self.uiData = uiData

        super.init(frame: CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height))

        let switchData = uiData.switchData ?? SwitchUIData()

        self.isOn = switchData.value == 1

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        let switchData = uiData.switchData ?? SwitchUIData()

        self.isOn = switchData.value == 1
    }
}

public class AppUISlider: UISlider {
    let uiData: UIData

    init(uiData: UIData) {
        self.uiData = uiData

        super.init(frame: CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height))

        let sliderData = uiData.sliderData ?? SliderUIData()

        self.minimumValue = sliderData.min
        self.maximumValue = sliderData.max
        self.value = sliderData.value

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    func reload() {
        let sliderData = uiData.sliderData ?? SliderUIData()

        self.minimumValue = sliderData.min
        self.maximumValue = sliderData.max
        self.value = sliderData.value
    }
}

public class EditorUI: UIView {

    let uiData: UIData

    var uiID: Int

    var uiName: String

    var delegate: EditorUIDelegate?

    var menu: UIMenuController

    private let ui: UIView

    private let wall: UIView

    init(uiData: UIData, ui: UIView) {
        self.uiData = uiData

        self.uiID = uiData.uiID

        self.uiName = uiData.uiName

        self.menu = UIMenuController.shared

        self.ui = ui

        self.wall = UIView()

        super.init(frame: CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height))

        self.addSubview(ui)
        ui.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        self.addSubview(self.wall)
        self.wall.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        self.bringSubviewToFront(self.wall)

        self.wall.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu(_:))))

        NSLayoutConstraint.activate(
                [
                    self.wall.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    self.wall.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    ui.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    ui.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                ]
        )

        /*
        ui.translatesAutoresizingMaskIntoConstraints = false
        wall.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
                [
                    ui.topAnchor.constraint(equalTo: self.topAnchor),
                    ui.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    ui.leftAnchor.constraint(equalTo: self.leftAnchor),
                    ui.rightAnchor.constraint(equalTo: self.rightAnchor),

                    wall.topAnchor.constraint(equalTo: self.topAnchor),
                    wall.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    wall.leftAnchor.constraint(equalTo: self.leftAnchor),
                    wall.rightAnchor.constraint(equalTo: self.rightAnchor),
                ]
        )
        */
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @objc func showMenu(_ sender: UITapGestureRecognizer) {
        if self.uiID < 0 {
            return
        }

        becomeFirstResponder()

        self.menu = UIMenuController.shared
        self.menu.isMenuVisible = true
        self.menu.arrowDirection = .down
        self.menu.setTargetRect(self.bounds, in: self)

        let editCodeMenu = UIMenuItem(title: "Code", action: #selector(self.editCode(sender:)))
        let editUIMenu = UIMenuItem(title: "Edit", action: #selector(self.editUI(sender:)))
        let menuItems = [editCodeMenu, editUIMenu]
        self.menu.menuItems = menuItems

        self.menu.setMenuVisible(true, animated: true)
    }

    public override var canBecomeFirstResponder: Bool {
        return true
    }

    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.editCode(sender:)) {
            return true
        }

        if action == #selector(self.editUI(sender:)) {
            return true
        }

        return false
    }

    @objc func editCode(sender: UIMenuItem) {
        self.delegate?.openCodeEditor(ui: self)
    }

    @objc func editUI(sender: UIMenuItem) {
        self.delegate?.editUI(ui: self)
    }

    func reloadFrame() {
        self.frame = CGRect(x: uiData.x, y: uiData.y, width: uiData.width, height: uiData.height)

        self.ui.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        self.wall.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
}

public class EditorUILabel: EditorUI {

    let label: AppUILabel

    let labelData: LabelUIData

    init(uiData: UIData) {
        self.labelData = uiData.labelData ?? LabelUIData()

        let ui = AppUILabel(uiData: uiData)
        self.label = ui

        super.init(uiData: uiData, ui: ui)

        //self.frame = super.frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        self.label.reload()
        self.reloadFrame()
    }
}

public class EditorUIButton: EditorUI {
    let button: AppUIButton

    let buttonData: ButtonUIData

    init(uiData: UIData) {
        self.buttonData = uiData.buttonData ?? ButtonUIData()

        let ui = AppUIButton(uiData: uiData)
        self.button = ui

        super.init(uiData: uiData, ui: ui)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        self.button.reload()
        self.reloadFrame()
    }
}

public class EditorUITextField: EditorUI {
    let textField: AppUITextField

    let textFieldData: TextFieldUIData

    init(uiData: UIData) {
        self.textFieldData = uiData.textFieldData ?? TextFieldUIData()

        let ui = AppUITextField(uiData: uiData)
        self.textField = ui

        super.init(uiData: uiData, ui: ui)
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    func reload() {
        self.textField.reload()
        self.reloadFrame()
    }
}

public class EditorUISwitch: EditorUI {
    let switchView: AppUISwitch

    let switchData: SwitchUIData

    init(uiData: UIData) {
        self.switchData = uiData.switchData ?? SwitchUIData()

        let ui = AppUISwitch(uiData: uiData)
        self.switchView = ui

        super.init(uiData: uiData, ui: ui)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        self.switchView.reload()
        self.reloadFrame()
    }
}

public class EditorUISlider: EditorUI {
    let slider: AppUISlider

    let sliderData: SliderUIData

    init(uiData: UIData) {
        self.sliderData = uiData.sliderData ?? SliderUIData()

        let ui = AppUISlider(uiData: uiData)
        self.slider = ui

        super.init(uiData: uiData, ui: ui)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        self.slider.reload()
        self.reloadFrame()
    }
}

protocol EditorUIDelegate {
    func openCodeEditor(ui: EditorUI)

    func editUI(ui: EditorUI)
}
