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

        /*
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        self.setTitle(uiData.text, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .highlighted)
        self.layer.cornerRadius = 7
        */

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

        let runApp = RunApp().topViewController() as! RunApp
        runApp.appUI[uiData.uiID!] = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScreenGenerator {
    public func generateScreen(inputUIData: [UIData]) -> UIView {

        let appView = UIView()

        /*
        let stackView = UIStackView()

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 20
        */

        for uiData in inputUIData {
            var ui: UIView = UIView()
            switch uiData.uiType {
            case 0:
                ui = AppButton(uiData: uiData, onButtonClickID: 2)
                break
            case 1:
                ui = AppLabel(uiData: uiData)
                break
            case 2:
                break
            default:
                break
            }

            appView.addSubview(ui)
            ui.center = CGPoint(x: uiData.x ?? 0, y: uiData.y ?? 0)

            /*
            let horizontalStackView = generateHorizontalStackView(inputUIData: i)

            stackView.addArrangedSubview(horizontalStackView)

            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            */
        }

        //return stackView

        appView.backgroundColor = UIColor.gray

        return appView
    }

    /*
    private func generateHorizontalStackView(inputUIData: [UIData_]) -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 20

        for i in inputUIData {
            if let id = i.uiID {
                var uiView: UIView?

                switch id {
                case 0:
                    //uiView = AppButton(uiData: i, onButtonClickID: i.uiID ?? 0)
                    uiView = AppButton(uiData: i, onButtonClickID: 2)

                case 1:
                    uiView = AppLabel(uiData: i)
                case 2:
                    uiView = generateSwitch(uiData: i)
                default:
                    break
                }


                if let view = uiView {
                    stackView.addArrangedSubview(view)
                }
            }
        }

        return stackView
    }
    */

    /*

    private func generateButton(uiData: UIData_) -> UIButton {
        let button = UIButton()

        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        button.setTitle(uiData.text, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), for: .highlighted)
        button.layer.cornerRadius = 7

        button.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)

        return button
    }

    private func generateTextLabel(uiData: UIData_) -> UILabel {
        let textLabel = UILabel()

        textLabel.text = uiData.text
        textLabel.textColor = UIColor.black

        return textLabel
    }

    private func generateSwitch(uiData: UIData_) -> UISwitch {
        let switchUI = UISwitch()

        return switchUI
    }

    @objc func buttonEvent(_ sender: UIButton) {
        print("button pressed!")
    }
    */

}
