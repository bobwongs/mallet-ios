//
//  ScreenGenerator.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppButton: AppUIButton {

    var uiData: UIData

    let onButtonClickID: Int

    init(uiData: UIData, onButtonClickID: Int) {
        self.uiData = uiData
        self.onButtonClickID = onButtonClickID

        super.init(frame: CGRect())

        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        self.setTitle(uiData.text, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .highlighted)
        self.layer.cornerRadius = 7

        self.sizeToFit()

        self.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)

        let runApp = RunApp().topViewController() as! RunApp
        runApp.appUI[uiData.uiID!] = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onButtonClick(_ sender: UIButton) {
        let runApp = RunApp().topViewController() as! RunApp
        runApp.RunCode(id: onButtonClickID)
    }

}

class AppLabel: UILabel {
    init(uiData: UIData) {
        super.init(frame: CGRect())

        self.text = uiData.text
        self.textColor = UIColor.black

        self.sizeToFit()
        self.textAlignment = NSTextAlignment.center

        let runApp = RunApp().topViewController() as! RunApp
        runApp.appUI[uiData.uiID!] = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScreenGenerator {

    public func generateScreen(inputUIData: [UIData], appView: UIView) {

        for uiData in inputUIData {
            var ui: UIView = UIView()
            switch uiData.uiType {
            case 0:
                ui = AppLabel(uiData: uiData)
                break
            case 1:
                ui = AppButton(uiData: uiData, onButtonClickID: uiData.uiID! + 2)
                break
            case 2:
                break
            default:
                break
            }

            appView.addSubview(ui)
            ui.center = CGPoint(x: uiData.x ?? 0, y: uiData.y ?? 0)
        }
    }
}
