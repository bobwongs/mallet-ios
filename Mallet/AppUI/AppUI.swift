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
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.text = "Text"
        self.textColor = UIColor.black
        self.font = font.withSize(22)

        self.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        self.setTitle("Button", for: .normal)
        self.titleLabel?.font = self.titleLabel?.font.withSize(17)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .highlighted)
        self.layer.cornerRadius = 7

        self.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public class AppUITextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }

        self.borderStyle = .roundedRect
        self.text = "Input"
        self.textColor = .black
        self.font = font?.withSize(17)
        self.sizeToFit()

        /*
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        */

        /*
        self.frame.size = CGSize(width: 50, height: 30)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        */
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
}

public class AppUISwitch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppUISlider: UISlider {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame.size = CGSize(width: 70, height: 40)

        self.minimumValue = 0
        self.maximumValue = 100
        self.value = 50

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
}

protocol EditorUIData {
    var uiType: UIType { get }
    var uiID: Int { set get }
    var uiName: String { set get }
}

public class EditorUI: UIView, EditorUIData {

    var delegate: EditorUIDelegate?

    let uiType: UIType
    var uiID: Int
    var uiName: String

    var menu: UIMenuController

    init(uiID: Int, uiName: String, uiType: UIType, ui: UIView, uiEditorController: UIEditorController) {
        self.delegate = uiEditorController

        self.uiType = uiType
        self.uiID = uiID
        self.uiName = uiName

        self.menu = UIMenuController.shared

        super.init(frame: CGRect())

        self.addSubview(ui)

        let wall = UIView()
        self.addSubview(wall)
        wall.frame = ui.frame

        self.bringSubviewToFront(wall)

        self.frame = ui.frame

        wall.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu(_:))))

        NSLayoutConstraint.activate(
                [
                    wall.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    wall.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    ui.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    ui.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                ]
        )

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

        let editCodeMenu = UIMenuItem(title: "Edit", action: #selector(self.editCode(sender:)))
        let editUIMenu = UIMenuItem(title: "Code", action: #selector(self.editUI(sender:)))
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
}

public class EditorUILabel: EditorUI {

    let label: AppUILabel

    init(uiID: Int, uiName: String, uiEditorController: UIEditorController) {
        let ui = AppUILabel()
        self.label = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .Label, ui: ui, uiEditorController: uiEditorController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class EditorUIButton: EditorUI {

    let button: AppUIButton

    var tap = ""

    init(uiID: Int, uiName: String, uiEditorController: UIEditorController) {
        let ui = AppUIButton()
        self.button = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .Button, ui: ui, uiEditorController: uiEditorController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class EditorUITextField: EditorUI {
    let textField: AppUITextField

    init(uiID: Int, uiName: String, uiEditorController: UIEditorController) {
        let ui = AppUITextField()
        self.textField = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .TextField, ui: ui, uiEditorController: uiEditorController)
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }
}

public class EditorUISwitch: EditorUI {

    let switchView: AppUISwitch

    init(uiID: Int, uiName: String, uiEditorController: UIEditorController) {
        let ui = AppUISwitch()
        self.switchView = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .Switch, ui: ui, uiEditorController: uiEditorController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class EditorUISlider: EditorUI {

    let slider: AppUISlider

    init(uiID: Int, uiName: String, uiEditorController: UIEditorController) {
        let ui = AppUISlider()
        self.slider = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .Slider, ui: ui, uiEditorController: uiEditorController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol EditorUIDelegate {
    func openCodeEditor(ui: EditorUI)

    func editUI(ui: EditorUI)
}