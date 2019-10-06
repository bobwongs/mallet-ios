//
//  AppDatabaseController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation
import Realm
import UIKit

class AppModel: RLMObject {
    @objc dynamic var appID = 0
    @objc dynamic var appName = ""
    @objc dynamic var uiDataStr = ""
    @objc dynamic var code = ""
    @objc dynamic var appVariable = RLMArray<AppVariableModel>(objectClassName: AppVariableModel.className())
}

class AppVariableModel: RLMObject {
    @objc dynamic var address = 0
    @objc dynamic var name = ""
    @objc dynamic var value = ""
}

@objcMembers
class AppDatabaseController: NSObject {

    static private func getUIDataStr(appData: AppData) -> String {
        let uiData = try? JSONEncoder().encode(appData.uiData)
        let uiDataStr = String(bytes: uiData ?? Data(), encoding: .utf8)

        return uiDataStr ?? ""
    }

    static private func getMaxAppID() -> Int {
        if AppModel.allObjects().count == 0 {
            return -1
        }

        let appModel = AppModel.allObjects().sortedResults(usingKeyPath: "appID", ascending: false).firstObject() as! AppModel

        return appModel.appID
    }

    static func createNewApp() -> AppData {
        return AppDatabaseController.createNewApp(appName: "Untitled App", uiData: [], code: "")
    }

    static func createNewApp(appName: String, uiData: [UIData], code: String) -> AppData {
        let appID = getMaxAppID() + 1

        let appData = AppData(appName: appName, appID: appID, uiData: uiData, code: code)

        do {
            let realm = RLMRealm.default()

            let appModel = AppModel()
            appModel.appID = appData.appID
            appModel.appName = appData.appName
            appModel.uiDataStr = getUIDataStr(appData: appData)
            appModel.code = appData.code

            realm.beginWriteTransaction()
            realm.add(appModel)
            try realm.commitWriteTransaction()

            print(AppModel.allObjects().count)
        } catch let error {
            print(error)
        }

        return appData
    }

    static func saveApp(appData: AppData) {
        DispatchQueue.global().async {
            autoreleasepool {
                do {
                    let realm = RLMRealm.default()

                    realm.beginWriteTransaction()

                    let currentAppModel = AppModel.objects(where: "appID == \(appData.appID)").firstObject() as! AppModel

                    currentAppModel.appName = appData.appName
                    currentAppModel.uiDataStr = getUIDataStr(appData: appData)
                    currentAppModel.code = appData.code

                    try realm.commitWriteTransaction()
                } catch let error {
                    print(error)
                }
            }
        }
    }

    static func getApp(appID: Int) -> AppData {
        do {
            guard let appModel: AppModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
                return createNewApp()
            }

            guard let jsonData = appModel.uiDataStr.data(using: .utf8) else {
                return createNewApp()
            }

            let uiData = try JSONDecoder().decode([UIData].self, from: jsonData)

            let appData = AppData(appName: appModel.appName, appID: appModel.appID, uiData: uiData, code: appModel.code)

            return appData

        } catch let error {
            print(error)
        }

        return createNewApp()
    }


    static func getAppList() -> [(Int, String)] {
        var appList = [(Int, String)]()

        let appModels = AppModel.allObjects()

        for appModel in appModels {
            guard let appModel: AppModel = appModel as! AppModel else {
                return appList
            }
            appList.append((appModel.appID, appModel.appName))
        }

        return appList
    }

    static func removeAllApp() {
        do {
            let realm = RLMRealm.default()

            let allApps = AppModel.allObjects()

            realm.beginWriteTransaction()
            for app in allApps {
                realm.delete(app)
            }
            try realm.commitWriteTransaction()
        } catch let error {
            print(error)
        }
    }

    static func removeApp(appID: Int) {
        do {
            let realm = RLMRealm.default()

            if let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() {
                realm.beginWriteTransaction()
                realm.delete(appModel)
                try realm.commitWriteTransaction()
            }
        } catch let error {
            print(error)
        }
    }

    static func initAppVariable(appID: Int, variables: [AppVariable]) {
        do {
            let realm = RLMRealm.default()

            guard let appModel = AppModel.objects(where: "AppID == \(appID)").firstObject() as? AppModel else {
                return
            }

            realm.beginWriteTransaction()

            for variable in variables {
                let appVariableModel = AppVariableModel()
                appVariableModel.address = variable.address
                appVariableModel.name = variable.name
                appVariableModel.value = variable.value

                appModel.appVariable.add(appVariableModel)
            }

            try realm.commitWriteTransaction()
        } catch let error {
            print(error)
        }
    }

    static func setAppVariable(appID: Int, varName: String, value: String) {
        DispatchQueue.global().async {
            autoreleasepool {
                do {
                    let realm = RLMRealm.default()

                    guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
                        return
                    }

                    if let variable = appModel.appVariable.objects(with: NSPredicate(format: "name == %@", argumentArray: [varName])).firstObject() {
                        realm.beginWriteTransaction()

                        variable.value = value

                        try realm.commitWriteTransaction()
                    } else {
                        let appVariableModel = AppVariableModel()
                        appVariableModel.address = -1
                        appVariableModel.name = varName
                        appVariableModel.value = value

                        realm.beginWriteTransaction()

                        appModel.appVariable.add(appVariableModel)

                        try realm.commitWriteTransaction()
                    }

                } catch let error {
                    print(error)
                }
            }
        }
    }

    static func setAppVariable(varName: String, value: String) {
        let appRunner = AppRunner.topAppRunner()

        if let appID = appRunner?.appData?.appID {
            AppDatabaseController.setAppVariable(appID: appID, varName: varName, value: value)
        }
    }

    static func getAppAllVariables(appID: Int, variableList: [VariableSettingsController.VariableData]) -> [VariableSettingsController.VariableData] {
        guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
            return []
        }

        var newVariableList = [VariableSettingsController.VariableData]()

        for variable in variableList {
            if variable.type == .persistent {
                let variableModels = appModel.appVariable.objects(with: NSPredicate(format: "name == %@", argumentArray: [variable.name]))

                if variableModels.count == 0 {
                    setAppVariable(varName: variable.name, value: "")
                    newVariableList.append(VariableSettingsController.VariableData(type: .persistent, name: variable.name, value: ""))
                } else {
                    newVariableList.append(VariableSettingsController.VariableData(type: .persistent, name: variable.name, value: variableModels.firstObject()!.value))
                }
            } else {
                newVariableList.append(variable)
            }
        }

        return newVariableList
    }

    static func getAppVariablesDictionary(appID: Int) -> Dictionary<String, String> {
        var dictionary = Dictionary<String, String>()

        guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
            return Dictionary<String, String>()
        }

        let variableModels = appModel.appVariable

        for variableModel in variableModels {
            guard let variable = variableModel as? AppVariableModel else {
                return Dictionary<String, String>()
            }

            dictionary[variable.name] = variable.value
        }

        return dictionary
    }

    static func getAppVariableValue(appID: Int, address: Int) -> String {
        guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
            return ""
        }

        let variable = appModel.appVariable.object(at: UInt(address))

        return variable.value
    }

    static func getAppVariableValue(address: Int) -> String {
        let appRunner = AppRunner.topAppRunner()

        if let appID = appRunner?.appData?.appID {
            return getAppVariableValue(appID: appID, address: address)
        }

        return ""
    }

    static func removeAllVariables(appID: Int) {
        do {
            let realm = RLMRealm.default()

            guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
                return
            }

            realm.beginWriteTransaction()

            for variable in appModel.appVariable {
                realm.delete(variable)
            }

            try realm.commitWriteTransaction()
        } catch let error {
            print(error)
        }
    }

    static func generateAppShortcutURL(appData: AppData) -> String {
        let appDataData = try? JSONEncoder().encode(appData)
        let base64Str = appDataData?.base64EncodedString()

        let url = "mallet-shortcut://i/\(base64Str ?? "")"

        UIPasteboard.general.string = url

        return url
    }

    static func decodeAppShortcutURL(base64Str: String) -> AppData {
        do {
            let appData = try JSONDecoder().decode(AppData.self, from: Data(base64Encoded: base64Str)!)
            return appData
        } catch let error {
            print(error)
            return createNewApp()
        }
    }

}
