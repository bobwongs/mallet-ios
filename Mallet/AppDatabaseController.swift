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

class AppDatabaseController {

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
        let appID = getMaxAppID() + 1
        let appName = "Untitled App"

        let appData = AppData(appName: appName, appID: appID, uiData: [], code: "")

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

    static func removeAll() {
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

    static func setAppVariable(appID: Int, address: Int, value: String) {
        do {
            let realm = RLMRealm.default()

            guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
                return
            }

            let variable = appModel.appVariable.object(at: UInt(address))

            realm.beginWriteTransaction()

            variable.value = value

            try realm.commitWriteTransaction()

        } catch let error {
            print(error)
        }
    }

    static func getAppAllVariables(appID: Int) -> [AppVariable] {
        guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
            return []
        }

        let variables = appModel.appVariable

        var variableList = [AppVariable]()

        for variable in variables {
            guard let variable = variable as? AppVariableModel else {
                return []
            }

            variableList.append(AppVariable(address: variable.address, name: variable.name, value: variable.value))
        }

        return variableList
    }

    static func getAppVariableValue(appID: Int, address: Int) -> String {
        guard let appModel = AppModel.objects(where: "appID == \(appID)").firstObject() as? AppModel else {
            return ""
        }

        let variable = appModel.appVariable.object(at: UInt(address))

        return variable.value
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
