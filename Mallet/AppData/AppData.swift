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
            do {
                let data = try JSONEncoder().encode(uiData)
                return String(data: data, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }

    static func json2UIData(jsonStr: String) -> Dictionary<Int, MUI>? {
        guard let data = jsonStr.data(using: .utf8) else {
            return nil
        }

        do {
            let dictionary = try JSONDecoder().decode([Int: MUI].self, from: data)
            return dictionary
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
