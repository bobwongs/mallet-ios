//
//  AppUI.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/06.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

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

protocol AppSampleUIData {
    var uiID: Int { set get }
    var uiType: Int { get }
}

public class AppSampleUILabel: AppUILabel, AppSampleUIData {
    var uiID = 0
    let uiType = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        let wall = UIView(frame: self.frame)
        self.addSubview(wall)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public class AppSampleUIButton: AppUIButton, AppSampleUIData {
    var uiID = 0
    let uiType = 1

    override init(frame: CGRect) {
        super.init(frame: frame)

        let wall = UIView(frame: self.frame)
        self.addSubview(wall)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppSampleUISwitch: AppUISwitch, AppSampleUIData {
    var uiID = 0
    var uiType = 2

    override init(frame: CGRect) {
        super.init(frame: frame)

        let wall = UIView(frame: self.frame)
        self.addSubview(wall)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
