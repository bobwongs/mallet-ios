//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/12.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsController: UITableViewController, UITextFieldDelegate {

    let appID: Int

    let ui: EditorUI

    let uiData: UIData

    let uiSettingsDelegate: UISettingsDelegate

    let codeEditorControllerDelegate: CodeEditorControllerDelegate

    init(appID: Int, ui: EditorUI, uiData: UIData, uiSettingsDelegate: UISettingsDelegate, codeEditorControllerDelegate: CodeEditorControllerDelegate) {
        self.appID = appID
        self.ui = ui
        self.uiData = uiData
        self.uiSettingsDelegate = uiSettingsDelegate
        self.codeEditorControllerDelegate = codeEditorControllerDelegate


        super.init(style: .grouped)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.allowsSelection = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + numberOfOtherSections() + 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }

        return titleForHeader(section: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }

        if section == numberOfOtherSections() + 1 {
            return 1
        }

        if section == numberOfOtherSections() + 2 {
            return 1
        }

        return numberOfRows(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        if indexPath.section == 0 {
            let titleLabel = UILabel()
            let textField = UITextField()

            textField.delegate = self

            textField.autocapitalizationType = .none

            let textFieldEvent: UIControl.Event = .editingDidEnd

            switch indexPath.row {
            case 0:
                titleLabel.text = "Name"
                textField.text = ui.uiData.uiName
                textField.addTarget(self, action: #selector(self.setUIName(_:)), for: textFieldEvent)

            case 1:
                titleLabel.text = "Position X"
                textField.text = "\(uiData.x)"
                textField.addTarget(self, action: #selector(self.setUIPosX(_:)), for: textFieldEvent)

            case 2:
                titleLabel.text = "Position Y"
                textField.text = "\(uiData.y)"
                textField.addTarget(self, action: #selector(self.setUIPosY(_:)), for: textFieldEvent)

            case 3:
                titleLabel.text = "Width"
                textField.text = "\(uiData.width)"
                textField.addTarget(self, action: #selector(self.setUIWidth(_:)), for: textFieldEvent)

            case 4:
                titleLabel.text = "Height"
                textField.text = "\(uiData.height)"
                textField.addTarget(self, action: #selector(self.setUIHeight(_:)), for: textFieldEvent)

            default:
                break
            }

            setCellWithInput(cell: cell, titleLabel: titleLabel, textField: textField)

            return cell
        }

        if indexPath.section == numberOfOtherSections() + 1 {
            cell.textLabel?.text = "Duplicate"
            cell.textLabel?.textColor = .systemBlue
            cell.textLabel?.textAlignment = .center

            return cell
        }

        if indexPath.section == numberOfOtherSections() + 2 {
            cell.textLabel?.text = "Delete"
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center

            return cell
        }

        return cellForRow(cell: cell, indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("### \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == numberOfOtherSections() + 1 {
            self.uiSettingsDelegate.duplicateUI(uiData: self.uiData)

            self.dismiss(animated: true)
        }

        if indexPath.section == numberOfOtherSections() + 2 {
            self.uiSettingsDelegate.deleteUI(uiID: self.uiData.uiID)

            self.dismiss(animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func numberOfOtherSections() -> Int {
        return 0
    }

    func titleForHeader(section: Int) -> String {
        return ""
    }

    func numberOfRows(section: Int) -> Int {
        return 0
    }

    func cellForRow(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        return cell
    }

    func setCellWithInput(cell: UITableViewCell, titleLabel: UILabel, textField: UITextField) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.frame.size = cell.frame.size
        cell.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true

        textField.delegate = self
    }


    @objc private func setUIName(_ textField: UITextField) {
        self.ui.uiData.uiName = textField.text ?? ""
        self.reload()
    }

    @objc private func setUIPosX(_ textField: UITextField) {
        self.uiData.x = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    @objc private func setUIPosY(_ textField: UITextField) {
        self.uiData.y = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    @objc private func setUIWidth(_ textField: UITextField) {
        self.uiData.width = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    @objc private func setUIHeight(_ textField: UITextField) {
        self.uiData.height = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    func reload() {
        self.ui.reload(uiData: uiData)

        self.uiSettingsDelegate.saveApp()
    }
}

public protocol UISettingsDelegate {
    func saveApp()

    func duplicateUI(uiData: UIData)

    func deleteUI(uiID: Int)
}