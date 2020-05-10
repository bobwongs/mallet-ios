//
//  Storage.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

class AppObject: Object {

    @objc dynamic var appID = 0

    @objc dynamic var appName = ""

    let uiIDs = List<Int>()

    @objc dynamic var uiDataJson = ""

}

class AppList: Object {

    @objc dynamic var listTitle = ""

    var apps = List<AppObject>()

    override class func primaryKey() -> String? {
        "listTitle"
    }
}

class Storage {

    static let mainAppListTitle = "main"

    static var maxAppID: Int {
        let realm = try! Realm()
        return realm.objects(AppObject.self).max(ofProperty: "appID") ?? 0
    }

    static func allAppLists() -> Results<AppList> {
        let realm = try! Realm()
        let allApps = realm.objects(AppList.self)

        if allApps.count > 0 {
            return allApps
        }

        do {
            try realm.write {
                let appList = AppList()
                appList.listTitle = mainAppListTitle
                realm.add(appList)
            }
        } catch {
            print(error.localizedDescription)
        }

        return realm.objects(AppList.self)
    }

    static func allApps() -> Results<AppObject> {
        let realm = try! Realm()
        return realm.objects(AppObject.self)
    }

    static func createNewApp() -> AppData {
        let appID = maxAppID + 1
        let appName = "New App"
        let uiIDs = [Int]()
        let uiData = Dictionary<Int, MUI>()

        let appData = AppData(appID: appID, appName: appName, uiIDs: uiIDs, uiData: uiData)

        saveApp(appData: appData)

        return appData
    }

    static func installApp(appData: AppData, sync: Bool = false) -> AppData {
        let appID = maxAppID + 1
        var newAppData = AppData(appID: appID, appName: appData.appName, uiIDs: appData.uiIDs, uiData: appData.uiData)

        if sync {
            saveAppSync(appData: appData)
        } else {
            saveApp(appData: appData)
        }

        return appData
    }

    static func loadApp(appID: Int) -> AppData {
        let realm = try! Realm()

        guard let appObject = realm.objects(AppObject.self).filter("appID == \(appID)").first else {
            print("failed to load app")
            return createNewApp()
        }

        let appName = appObject.appName
        let uiIDs: [Int] = appObject.uiIDs.map({ $0 })

        guard let uiData = AppData.json2UIData(jsonStr: appObject.uiDataJson) else {
            print("failed to load app")
            return createNewApp()
        }

        return AppData(appID: appID, appName: appName, uiIDs: uiIDs, uiData: uiData)
    }

    static func saveApp(appData: AppData) {
        DispatchQueue(label: "background").async {
            saveAppSync(appData: appData)
        }
    }

    static func saveAppSync(appData: AppData) {
        autoreleasepool {
            guard let uiDataJson = AppData.uiData2Json(uiData: appData.uiData) else {
                print("failed to save app")
                return
            }

            let realm = try! Realm()

            guard  let appList = realm.object(ofType: AppList.self, forPrimaryKey: mainAppListTitle) else {
                return
            }

            if let appObject = realm.objects(AppObject.self).filter("appID == \(appData.appID)").first {

                let uiIDs = List<Int>()
                appData.uiIDs.forEach({ uiIDs.append($0) })

                do {
                    try realm.write {
                        appObject.appName = appData.appName
                        appObject.uiDataJson = uiDataJson

                        appObject.uiIDs.removeAll()
                        appData.uiIDs.forEach({ appObject.uiIDs.append($0) })
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                let appObject = AppObject()
                appObject.appID = appData.appID
                appObject.appName = appData.appName
                appData.uiIDs.forEach({ appObject.uiIDs.append($0) })
                appObject.uiDataJson = uiDataJson

                do {
                    try realm.write {
                        appList.apps.append(appObject)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    static func deleteApp(appID: Int) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()

                guard  let appList = realm.object(ofType: AppList.self, forPrimaryKey: mainAppListTitle) else {
                    return
                }

                guard  let appObject = realm.objects(AppObject.self).filter("appID == \(appID)").first else {
                    return
                }

                do {
                    try realm.write {
                        if let idx = appList.apps.index(matching: "appID == \(appID)") {
                            appList.apps.remove(at: idx)
                        }
                        realm.delete(appObject)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    static func moveApp(_ from: Int, _ to: Int) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()

                guard  let appList = realm.object(ofType: AppList.self, forPrimaryKey: mainAppListTitle) else {
                    return
                }

                do {
                    try realm.write {
                        appList.apps.move(from: from, to: to)
                    }
                } catch {
                    print(error.localizedDescription)
                }

            }
        }
    }

}
