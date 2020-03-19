//
//  Storage.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/19.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation
import RealmSwift

class AppRealmObject: Object {

    @objc dynamic var appID = 0

    @objc dynamic var appName = ""

    var uiIDs = List<Int>()

    @objc dynamic var uiDataJson = ""

}

class Storage {

    static var maxAppID: Int {
        let realm = try! Realm()
        return realm.objects(AppRealmObject.self).max(ofProperty: "appID") ?? 0
    }

    static func allApps() -> Results<AppRealmObject> {
        let realm = try! Realm()
        return realm.objects(AppRealmObject.self)
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

    static func loadApp(appID: Int) -> AppData {
        let realm = try! Realm()

        guard let appRealmObject = realm.objects(AppRealmObject.self).filter("appID == \(appID)").first else {
            print("failed to load app")
            return createNewApp()
        }

        let appName = appRealmObject.appName
        var uiIDs = [Int]()
        appRealmObject.uiIDs.forEach({ uiIDs.append($0) })

        guard let uiData = AppData.json2UIData(jsonStr: appRealmObject.uiDataJson) else {
            print("failed to load app")
            return createNewApp()
        }

        return AppData(appID: appID, appName: appName, uiIDs: uiIDs, uiData: uiData)
    }

    static func saveApp(appData: AppData) {
        guard let uiDataJson = AppData.uiData2Json(uiData: appData.uiData) else {
            print("failed to save app")
            return
        }

        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()

                if let appRealmObject = realm.objects(AppRealmObject.self).filter("appID == \(appData.appID)").first {
                    do {
                        try realm.write {
                            appRealmObject.appName = appData.appName
                            appRealmObject.uiDataJson = uiDataJson

                            let uiIDs = List<Int>()
                            appData.uiIDs.forEach({ uiIDs.append($0) })
                            appRealmObject.uiIDs = uiIDs
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    let appRealmObject = AppRealmObject()
                    appRealmObject.appID = appData.appID
                    appRealmObject.appName = appData.appName
                    appData.uiIDs.forEach({ appRealmObject.uiIDs.append($0) })
                    appRealmObject.uiDataJson = uiDataJson

                    do {
                        try realm.write {
                            realm.add(appRealmObject)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    static func deleteApp(appID: Int) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()

                guard  let appRealmObject = realm.objects(AppRealmObject.self).filter("appID == \(appID)").first else {
                    return
                }

                do {
                    try realm.write {
                        realm.delete(appRealmObject)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

}
