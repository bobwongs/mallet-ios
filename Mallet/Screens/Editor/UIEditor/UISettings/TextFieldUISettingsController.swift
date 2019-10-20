//
//  TextFieldUISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class TextFieldUISettingsController: UISettingsController {

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
            return "Text Field"
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
                textField.text = uiData.textFieldData?.text ?? ""
                textField.addTarget(self, action: #selector(self.setText(_:)), for: textFieldEvent)

            case 1:
                titleLabel.text = "Font Size"
                textField.text = "\(uiData.textFieldData?.fontSize ?? 0)"
                textField.addTarget(self, action: #selector(self.setFontSize(_:)), for: textFieldEvent)

            case 2:
                titleLabel.text = "Font Color"
                textField.text = uiData.textFieldData?.fontColor
                textField.addTarget(self, action: #selector(self.setFontColor(_:)), for: textFieldEvent)

            case 3:
                titleLabel.text = "Alignment"
                let text: String!
                switch (uiData.textFieldData?.alignment ?? TextUIAlignment.left) {
                case .center:
                    text = "center"
                case .left:
                    text = "left"
                case .right:
                    text = "right"
                }
                textField.text = text

                textField.addTarget(self, action: #selector(self.setTextAlignment(_:)), for: textFieldEvent)

            default:
                break
            }

            setCellWithInput(cell: cell, titleLabel: titleLabel, textField: textField)

        case 2:
            cell.accessoryType = .disclosureIndicator
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Changed"
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
                    self.uiData.textFieldData?.code[.OnChange]?.code = code
                }
                codeStr = self.uiData.textFieldData?.code[.OnChange]?.code ?? ""
                codeTitle = "Changed"

            default:
                return
            }

            let storyboard = UIStoryboard(name: "CodeEditor", bundle: nil)

            guard let codeEditorController = storyboard.instantiateInitialViewController() as? CodeEditorController else {
                fatalError()
            }

            codeEditorController.codeEditorControllerDelegate = self.codeEditorControllerDelegate

            codeEditorController.updateCodeClosure = updateCodeClosure

            codeEditorController.codeStr = codeStr

            codeEditorController.codeTitle = codeTitle

            codeEditorController.appID = self.appID

            navigationController?.pushViewController(codeEditorController, animated: true)
        }
    }

    @objc private func setText(_ textField: UITextField) {
        self.uiData.textFieldData?.text = textField.text ?? ""
        self.reload()
    }

    @objc private func setFontSize(_ textField: UITextField) {
        self.uiData.textFieldData?.fontSize = Int(textField.text ?? "") ?? 0
        self.reload()
    }

    @objc private func setFontColor(_ textField: UITextField) {
        self.uiData.textFieldData?.fontColor = textField.text ?? ""
        self.reload()
    }

    @objc private func setTextAlignment(_ textField: UITextField) {
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
        self.uiData.textFieldData?.alignment = alignment
        self.reload()
    }
}
