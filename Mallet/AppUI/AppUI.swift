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
    case Switch
}

public class AppUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.text = "Text"
        self.textColor = UIColor.black

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

public class AppUISwitch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol EditorUIData {
    var uiType: UIType { get }
    var uiID: Int { set get }
    var uiName: String { set get }
}

public class EditorUI: UIView, EditorUIData {

    let uiType: UIType
    var uiID: Int
    var uiName: String

    var menu: UIMenuController

    init(uiID: Int, uiName: String, uiType: UIType, ui: UIView) {
        self.uiType = uiType
        self.uiID = uiID
        self.uiName = uiName

        self.menu = UIMenuController.shared

        super.init(frame: CGRect())

        self.addSubview(ui)
        ui.translatesAutoresizingMaskIntoConstraints = false

        let wall = UIView()
        self.addSubview(wall)
        wall.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    wall.topAnchor.constraint(equalTo: ui.topAnchor),
                    wall.bottomAnchor.constraint(equalTo: ui.bottomAnchor),
                    wall.leftAnchor.constraint(equalTo: ui.leftAnchor),
                    wall.rightAnchor.constraint(equalTo: ui.rightAnchor)
                ]
        )

        self.bringSubviewToFront(wall)

        self.layoutIfNeeded()
        self.frame = wall.frame

        wall.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu(_:))))
        //self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu(_:))))

        //self.translatesAutoresizingMaskIntoConstraints = false
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

        let editCodeMenu = UIMenuItem(title: "Edit Code", action: #selector(self.editCode(sender:)))
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

    }

    @objc func editUI(sender: UIMenuItem) {

    }
}

public class EditorUILabel: EditorUI {

    let label: AppUILabel

    init(uiID: Int, uiName: String) {
        let ui = AppUILabel()
        self.label = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .Label, ui: ui)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class EditorUIButton: EditorUI {

    let button: AppUIButton

    var tap = ""

    init(uiID: Int, uiName: String) {
        let ui = AppUIButton()
        self.button = ui

        super.init(uiID: uiID, uiName: uiName, uiType: .Button, ui: ui)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class EditorUISwitch: AppUISwitch, EditorUIData {
    let uiType = UIType.Switch
    var uiID: Int
    var uiName: String

    init(uiID: Int, uiName: String) {
        self.uiID = uiID
        self.uiName = uiName

        super.init(frame: CGRect())

        let wall = UIView(frame: self.frame)
        self.addSubview(wall)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
