//
//  ButtonUISettingsTableView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/11.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ButtonUISettingsTableView: DefaultUISettingsTableView {
    override init(frame: CGRect, ui: EditorUI, uiData: UIData, uiSettingsController: UISettingsController) {
        super.init(frame: frame, ui: ui, uiData: uiData, uiSettingsController: uiSettingsController)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func numberOfOtherSections() -> Int {
        return 2
    }

    override func titleForHeader(section: Int) -> String {
        switch section {
        case 1:
            return "Button"
        case 2:
            return "Code"
        default:
            return ""
        }
    }

    override func numberOfRows(section: Int) -> Int {
        switch section {
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func cellForRow(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let titleLabel = UILabel()
            let textField = UITextField()

            textField.delegate = self

            textField.autocapitalizationType = .none

            let textFieldEvent: UIControl.Event = .editingDidEnd

            switch indexPath.row {
            case 0:
                titleLabel.text = "Text"
                textField.text = uiData.buttonData?.text ?? ""
                textField.addTarget(self, action: #selector(self.setButtonText(_:)), for: textFieldEvent)

            case 1:
                titleLabel.text = "Font Size"
                textField.text = "\(uiData.buttonData?.fontSize ?? 0)"
                textField.addTarget(self, action: #selector(self.setButtonFontSize(_:)), for: textFieldEvent)

            case 2:
                titleLabel.text = "Font Color"
                textField.text = uiData.buttonData?.fontColor
                textField.addTarget(self, action: #selector(self.setButtonFontColor(_:)), for: textFieldEvent)

            case 3:
                titleLabel.text = "Background Color"
                textField.text = uiData.buttonData?.backgroundColor
                textField.addTarget(self, action: #selector(self.setButtonBackgroundColor(_:)), for: textFieldEvent)

            default:
                break
            }

            setCellWithInput(cell: cell, titleLabel: titleLabel, textField: textField)

        case 2:
            cell.accessoryType = .detailDisclosureButton
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Tap"
            default:
                break
            }

        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        /*
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
            default:
                break
            }
        }
        */
    }

    @objc private func setButtonText(_ textField: UITextField) {
        self.uiData.buttonData?.text = textField.text ?? ""
        self.reload()
    }

    @objc private func setButtonFontSize(_ textField: UITextField) {
        self.uiData.buttonData?.fontSize = Int(textField.text ?? "") ?? 0
        self.reload()
    }

    @objc private func setButtonFontColor(_ textField: UITextField) {
        self.uiData.buttonData?.fontColor = textField.text ?? ""
        self.reload()
    }

    @objc private func setButtonBackgroundColor(_ textField: UITextField) {
        self.uiData.buttonData?.backgroundColor = textField.text ?? ""
        self.reload()
    }
}
