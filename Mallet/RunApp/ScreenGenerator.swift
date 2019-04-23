//
//  ScreenGenerator.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ScreenGenerator {
    public func generateScreen(inputUIData: [[UIData]]) -> UIStackView {

        let stackView = UIStackView()

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 20

        for i in inputUIData {
            let horizontalStackView = generateHorizontalStackView(inputUIData: i)

            stackView.addArrangedSubview(horizontalStackView)

            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        }

        return stackView
    }

    private func generateHorizontalStackView(inputUIData: [UIData]) -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 20

        for i in inputUIData {
            if let id = i.uiID {
                var uiView: UIView?

                switch id {
                case 0:
                    uiView = generateButton(uiData: i)
                case 1:
                    uiView = generateTextLabel(uiData: i)
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

    private func generateButton(uiData: UIData) -> UIButton {
        let button = UIButton()

        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        button.setTitle(uiData.text, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 7

        return button
    }

    private func generateTextLabel(uiData: UIData) -> UILabel {
        let textLabel = UILabel()

        textLabel.text = uiData.text
        textLabel.textColor = UIColor.black

        return textLabel
    }

    private func generateSwitch(uiData: UIData) -> UISwitch {
        let switchUI = UISwitch()

        return switchUI
    }
}
