//
//  SliderUISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class SliderUISettingsController: UISettingsController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(appID: Int, ui: EditorUI, uiData: UIData, uiSettingsDelegate: UISettingsDelegate, codeEditorControllerDelegate: CodeEditorControllerDelegate, editorDelegate: EditorDelegate) {
        super.init(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)
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
            return "Slider"
        case 2:
            return "Code"
        default:
            return ""
        }
    }

    override func numberOfRows(section: Int) -> Int {
        switch section {
        case 1:
            return 3
        case 2:
            return SliderUIData.CodeType.allCases.count
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
                titleLabel.text = "Value"
                textField.text = String(uiData.sliderData?.value ?? 0)
                textField.addTarget(self, action: #selector(self.setSliderValue(_:)), for: textFieldEvent)

            case 1:
                titleLabel.text = "Minimum Value"
                textField.text = String(uiData.sliderData?.min ?? 0)
                textField.addTarget(self, action: #selector(self.setSliderMinValue(_:)), for: textFieldEvent)

            case 2:
                titleLabel.text = "Maximum Value"
                textField.text = String(uiData.sliderData?.max ?? 0)
                textField.addTarget(self, action: #selector(self.setSliderMaxValue(_:)), for: textFieldEvent)

            default:
                break
            }

            setCellWithInput(cell: cell, titleLabel: titleLabel, textField: textField)

        case 2:
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "When started"
            case 1:
                cell.textLabel?.text = "When changed"
            case 2:
                cell.textLabel?.text = "When ended"
            default:
                break
            }

        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)

        if indexPath.section == 2 {
            let updateCodeClosure: ((String) -> Void)!
            let codeStr: String!
            let codeTitle: String!

            switch indexPath.row {
            case 0:
                updateCodeClosure = { (code) in
                    self.uiData.sliderData?.code[.OnStart]?.code = code
                }
                codeStr = self.uiData.sliderData?.code[.OnStart]?.code ?? ""
                codeTitle = "When started"

            case 1:
                updateCodeClosure = { (code) in
                    self.uiData.sliderData?.code[.OnChange]?.code = code
                }
                codeStr = self.uiData.sliderData?.code[.OnChange]?.code ?? ""
                codeTitle = "When changed"

            case 2:
                updateCodeClosure = { (code) in
                    self.uiData.sliderData?.code[.OnEnd]?.code = code
                }
                codeStr = self.uiData.sliderData?.code[.OnEnd]?.code ?? ""
                codeTitle = "When ended"


            default:
                return
            }

            self.openCodeEditor(updateCodeClosure: updateCodeClosure, codeStr: codeStr, codeTitle: codeTitle)
        }


    }

    @objc private func setSliderValue(_ textField: UITextField) {
        self.uiData.sliderData?.value = Float(textField.text ?? "") ?? 0.0
        self.reload()
    }

    @objc private func setSliderMaxValue(_ textField: UITextField) {
        self.uiData.sliderData?.max = Float(textField.text ?? "") ?? 0.0
        self.reload()
    }

    @objc private func setSliderMinValue(_ textField: UITextField) {
        self.uiData.sliderData?.min = Float(textField.text ?? "") ?? 0.0
        self.reload()
    }
}
