//
//  LabelUISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/12.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class LabelUISettingsController: UISettingsController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(ui: EditorUI, uiData: UIData, uiSettingsDelegate: UISettingsDelegate) {
        super.init(ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func numberOfOtherSections() -> Int {
        return 1
    }

    override func titleForHeader(section: Int) -> String {
        switch section {
        case 1:
            return "Label"
        default:
            return ""
        }
    }

    override func numberOfRows(section: Int) -> Int {
        switch section {
        case 1:
            return 4
        default:
            return 0
        }
    }

    override func cellForRow(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        let titleLabel = UILabel()
        let textField = UITextField()

        textField.delegate = self

        textField.autocapitalizationType = .none

        let textFieldEvent: UIControl.Event = .editingDidEnd

        switch indexPath.row {
        case 0:
            titleLabel.text = "Text"
            textField.text = uiData.labelData?.text ?? ""
            textField.addTarget(self, action: #selector(self.setLabelText(_:)), for: textFieldEvent)

        case 1:
            titleLabel.text = "Font Size"
            textField.text = "\(uiData.labelData?.fontSize ?? 0)"
            textField.addTarget(self, action: #selector(self.setLabelFontSize(_:)), for: textFieldEvent)

        case 2:
            titleLabel.text = "Font Color"
            textField.text = uiData.labelData?.fontColor
            textField.addTarget(self, action: #selector(self.setLabelFontColor(_:)), for: textFieldEvent)

        case 3:
            titleLabel.text = "Alignment"
            let text: String!
            switch (uiData.labelData?.alignment ?? TextUIAlignment.left) {
            case .center:
                text = "center"
            case .left:
                text = "left"
            case .right:
                text = "right"
            }
            textField.text = text
            textField.addTarget(self, action: #selector(self.setLabelTextAlignment(_:)), for: textFieldEvent)


        default:
            break
        }

        setCellWithInput(cell: cell, titleLabel: titleLabel, textField: textField)

        return cell
    }


    @objc private func setLabelText(_ textField: UITextField) {
        self.uiData.labelData?.text = textField.text ?? ""
        self.reload()
    }

    @objc private func setLabelFontSize(_ textField: UITextField) {
        self.uiData.labelData?.fontSize = Int(textField.text ?? "") ?? 0
        self.reload()
    }

    @objc private func setLabelFontColor(_ textField: UITextField) {
        self.uiData.labelData?.fontColor = textField.text ?? ""
        self.reload()
    }

    @objc private func setLabelTextAlignment(_ textField: UITextField) {
        let alignment: TextUIAlignment!
        switch textField.text {
        case "center":
            alignment = .center
        case "left":
            alignment = .left
        case "right":
            alignment = .right
        default:
            alignment = .left
        }
        self.uiData.labelData?.alignment = alignment
        self.reload()
    }
}
