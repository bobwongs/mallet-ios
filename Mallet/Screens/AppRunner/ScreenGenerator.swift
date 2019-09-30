//
//  ScreenGenerator.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppButton: AppUIButton {
    let onButtonClickID: Int

    override init(uiData: UIData) {
        let buttonData = uiData.buttonData ?? ButtonUIData()

        self.onButtonClickID = buttonData.onTap.funcID

        super.init(uiData: uiData)

        self.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)

        let appRunner = AppRunner().topViewController() as! AppRunner
        appRunner.appUI[uiData.uiID] = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onButtonClick(_ sender: UIButton) {
        let appRunner = AppRunner().topViewController() as! AppRunner

        DispatchQueue.global(qos: .default).async() {
            appRunner.CallFunc(id: self.onButtonClickID)
        }
    }
}

class AppLabel: AppUILabel {
    override init(uiData: UIData) {
        super.init(uiData: uiData)

        let runApp = AppRunner().topViewController() as! AppRunner
        runApp.appUI[uiData.uiID] = self
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
            case .Label:
                ui = AppLabel(uiData: uiData)
                break

            case .Button:
                ui = AppButton(uiData: uiData)
                break

            case .TextField:
                break

            case .Switch:
                break

            case .Slider:
                break

            case .Table:
                break
            }

            appView.addSubview(ui)
            ui.center = CGPoint(x: uiData.x, y: uiData.y)
        }
    }
}
