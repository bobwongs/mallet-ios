//
//  VariableSettingsControllerTableViewController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VariableSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, VariableSettingsCellDelegate, ListSettingsCellDelegate {

    enum VariableType {
        case normal
        case persistent
        case cloud
    }

    struct VariableData {
        var type: VariableType
        var name: String
        var value: String
        var isUI: Bool

        init(type: VariableType, name: String, value: String, isUI: Bool) {
            self.type = type
            self.name = name
            self.value = value
            self.isUI = isUI
        }
    }

    struct ListData {
        var type: VariableType
        var name: String
        var value: [String]
        var isUI: Bool
        var uiID: Int?

        init(type: VariableType, name: String, value: [String], isUI: Bool, uiID: Int? = nil) {
            self.type = type
            self.name = name
            self.value = value
            self.isUI = isUI
            self.uiID = uiID
        }
    }

    @IBOutlet weak var variableTableView: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!

    var codeEditorControllerDelegate: CodeEditorControllerDelegate?

    var appID: Int?

    var codeStr: String?

    var varList = [VariableData]()

    var listList = [ListData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)

        self.variableTableView.delegate = self
        self.variableTableView.dataSource = self

        self.navigationBar.delegate = self

        initVariables()
        initLists()

        CloudVariableController.startVariableSettings(variableSettingsController: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.setGlobalVariableCode()
    }

    func initVariables() {
        if let codeStr = self.codeStr {
            guard let variables = ConverterObjCpp().getGlobalVariables(codeStr) else {
                print("Error : failed to get global variables")
                return
            }

            self.varList.removeAll()

            for variable in variables {
                guard let variable = variable as? VariableDataObjC else {
                    continue
                }

                let type: VariableType!
                switch variable.type {
                case "normal":
                    type = .normal
                case "persistent":
                    type = .persistent
                case "cloud":
                    type = .cloud
                default:
                    type = .normal
                }

                //TODO:

                self.varList.append(VariableData(type: type, name: variable.name, value: variable.value, isUI: false))
            }
        }

        if let appID = self.appID {
            varList = AppDatabaseController.getAppAllVariables(appID: appID, variableList: varList)
        }

        variableTableView.reloadData()
    }

    func initLists() {
        if let codeStr = self.codeStr {
            guard  let lists = ConverterObjCpp().getGlobalLists(codeStr) else {
                print("Error : failed to get global lists")
                return
            }

            self.listList.removeAll()

            print(lists.count)

            for list in lists {
                guard let list = list as? ListDataObjC else {
                    continue
                }

                let type: VariableType!
                switch list.type {
                case "normal":
                    type = .normal
                case "persistent":
                    type = .persistent
                case "cloud":
                    type = .cloud
                default:
                    type = .normal
                }

                var listValue = [String]()
                for element in list.value {
                    listValue.append((element as? String) ?? "")
                }

                self.listList.append(ListData(type: type, name: list.name, value: listValue, isUI: list.uiID != -1, uiID: Int(list.uiID)))
            }
        }

        print(self.listList)
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varList.count + listList.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row < varList.count {
            let cell = VariableSettingsCell(reuseIdentifier: "Cell", index: indexPath.row, variableData: varList[indexPath.row])

            cell.delegate = self

            return cell
        } else {
            let index = indexPath.row - varList.count

            let cell = ListSettingsCell(reuseIdentifier: "Cell", index: index, listData: listList[index], delegate: self)

            return cell
        }
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

            self.setPersistentVariable(index: index)
        })

        let action_saveToCloud = UIAlertAction(title: "Save to cloud", style: .default, handler: {
            (action: UIAlertAction!) in
            cell.updateVariableType(type: .cloud)
            self.varList[index].type = .cloud

            self.setCloudVariable(index: index)
        })

        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action_normal)
        alert.addAction(action_saveToDevice)
        alert.addAction(action_saveToCloud)
        alert.addAction(action_cancel)

        self.present(alert, animated: true)
    }

    func setPersistentVariable(index: Int) {
        if self.varList[index].name == "" {
            return
        }

        if let appID = self.appID {
            AppDatabaseController.setAppVariable(appID: appID, varName: self.varList[index].name, value: self.varList[index].value)
        }
    }

    func setCloudVariable(index: Int) {
        if self.varList[index].name == "" {
            return
        }

        CloudVariableController.setCloudVariable(varName: self.varList[index].name, value: self.varList[index].value)
    }

    func updateVariableName(index: Int, name: String) {
        self.varList[index].name = name

        if (self.varList[index].type == .persistent) {
            self.setPersistentVariable(index: index)
        }

        if (self.varList[index].type == .cloud) {
            self.setCloudVariable(index: index)
        }
    }

    func updateVariableValue(index: Int, value: String) {
        self.varList[index].value = value

        if (self.varList[index].type == .persistent) {
            self.setPersistentVariable(index: index)
        }

        if (self.varList[index].type == .cloud) {
            self.setCloudVariable(index: index)
        }
    }

    func updateListType(index: Int, cell: ListSettingsCell) {
        //TODO:
    }

    func updateListName(index: Int, name: String) {
        //TODO:
    }

    func updateListValue(index: Int, value: [String]) {
        //TODO:
    }

    @objc func closePickerView() {
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func addVariableButton(_ sender: Any) {
        self.varList.append(VariableData(type: .normal, name: "", value: "", isUI: false))
        variableTableView.reloadData()
    }

    func updateCloudVariable(variables: NSDictionary) {
        for i in 0..<self.varList.count {
            if self.varList[i].type == .cloud {
                if let value = variables[self.varList[i].name] {
                    self.varList[i].value = value as? String ?? ""
                }
            }
        }

        variableTableView.reloadData()
    }

    func setGlobalVariableCode() {
        var code = ""

        for variable in varList {
            if (variable.name == "") {
                continue
            }

            code += "var "
            switch variable.type {
            case .normal:
                code += "\(variable.name) = \"\(variable.value)\""
            case .persistent:
                code += "#persistent \(variable.name)"
            case .cloud:
                code += "#cloud \(variable.name)"
            }

            code += "\n"
        }

        codeEditorControllerDelegate?.setGlobalVariableCode(code: code)
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
