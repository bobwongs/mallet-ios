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

public class EditorUILabel: AppUILabel, EditorUIData {
    let uiType = UIType.Label
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

public class EditorUIButton: AppUIButton, EditorUIData {
    let uiType = UIType.Button
    var uiID: Int
    var uiName: String

    var tap = ""

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
