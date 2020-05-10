//
//  AppData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/02.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import Foundation

class AppData: Codable {

    let appID: Int

    let appName: String

    let uiIDs: [Int]

    let uiData: Dictionary<Int, MUI>

    init(appID: Int, appName: String, uiIDs: [Int], uiData: Dictionary<Int, MUI>) {
        self.appID = appID
        self.appName = appName
        self.uiIDs = uiIDs
        self.uiData = uiData
    }

    static func uiData2Json(uiData: Dictionary<Int, MUI>) -> String? {
        do {
            let data = try JSONEncoder().encode(uiData)
            return String(data: data, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    static func json2UIData(jsonStr: String) -> Dictionary<Int, MUI>? {
        guard let json = jsonStr.data(using: .utf8) else {
            return nil
        }
        return json2UIData(json: json)
    }

    static func json2UIData(json: Data) -> Dictionary<Int, MUI>? {
        do {
            let dictionary = try JSONDecoder().decode([Int: MUI].self, from: json)
            return dictionary
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    static func appData2Json(appData: AppData) -> String? {
        do {
            let data = try JSONEncoder().encode(appData)
            return String(data: data, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    static func json2AppData(jsonStr: String) -> AppData? {
        guard  let json = jsonStr.data(using: .utf8) else {
            return nil
        }
        return json2AppData(json: json)
    }

    static func json2AppData(json: Data) -> AppData? {
        do {
            let appData = try JSONDecoder().decode(AppData.self, from: json)
            return appData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
