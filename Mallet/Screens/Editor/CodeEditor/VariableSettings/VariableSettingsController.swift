//
//  VariableSettingsControllerTableViewController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VariableSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, VariableSettingsCellDelegate {

    enum VariableType {
        case normal
        case persistent
        case cloud
    }

    struct VariableData {
        var type: VariableType
        var address: Int
        var name: String
        var value: String

        init(type: VariableType, address: Int, name: String, value: String) {
            self.type = type
            self.address = address
            self.name = name
            self.value = value
        }
    }

    @IBOutlet weak var variableTableView: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!

    public var varList = [VariableData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.variableTableView.delegate = self
        self.variableTableView.dataSource = self

        self.navigationBar.delegate = self
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varList.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VariableSettingsCell(reuseIdentifier: "Cell", index: indexPath.row, variableData: varList[indexPath.row])

        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            varList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func updateVariableType(index: Int, cell: VariableSettingsCell) {
        let alert = UIAlertController(title: "Variable Type", message: nil, preferredStyle: .actionSheet)

        let action_normal = UIAlertAction(title: "Normal (Don't save)", style: .default, handler: {
            (action: UIAlertAction!) in
            cell.updateVariableType(type: .normal)
            self.varList[index].type = .normal
        })

        let action_saveToDevice = UIAlertAction(title: "Save to this device", style: .default, handler: {
            (action: UIAlertAction!) in
            cell.updateVariableType(type: .persistent)
            self.varList[index].type = .persistent
        })

        let action_saveToCloud = UIAlertAction(title: "Save to cloud", style: .default, handler: {
            (action: UIAlertAction!) in
            cell.updateVariableType(type: .cloud)
            self.varList[index].type = .cloud
        })

        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action_normal)
        alert.addAction(action_saveToDevice)
        alert.addAction(action_saveToCloud)
        alert.addAction(action_cancel)

        self.present(alert, animated: true)
    }

    func updateVariableName(index: Int, name: String) {
        self.varList[index].name = name
    }

    func updateVariableValue(index: Int, value: String) {
        self.varList[index].value = value
    }

    @objc func closePickerView() {
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func addVariableButton(_ sender: Any) {
        self.varList.append(VariableData(type: .normal, address: -1, name: "", value: ""))
        variableTableView.reloadData()
    }
}

struct AppVariable {
    var address: Int
    var name: String
    var value: String

    init(address: Int, name: String, value: String) {
        self.address = address
        self.name = name
        self.value = value
    }
}
