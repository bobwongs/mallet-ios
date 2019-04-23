//
//  ScreenDataController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public struct UIData: Codable {
    let uiID: Int?
    let text: String?
    let value: Int?

    init(uiID: Int, text: String, value: Int) {
        self.uiID = uiID
        self.text = text
        self.value = value
    }
}

public class ScreenDataController {

    public func generateRandomUIData() -> [[UIData]] {
        var randomUIData = [[UIData]]()

        for i in 0..<10 {
            randomUIData.append([UIData]())
            for _ in 2...4 {
                let uiID = Int.random(in: 0..<3)
                let text = "Text"
                let value = 0
                let uiData = UIData(uiID: uiID, text: text, value: value)

                randomUIData[i].append(uiData)
            }
        }

        return randomUIData
    }

    public func saveUIData(saveData: [[UIData]]) {
        do {
            let jsonData = try JSONEncoder().encode(saveData)
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            print(jsonStr)

            let fileName = "uiData.json"

            if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent(fileName)

                print(targetTextFilePath)

                do {
                    try jsonStr.write(to: targetTextFilePath, atomically: true, encoding: String.Encoding.utf8)
                } catch let error as NSError {
                    print("failed to write...(;_;) \(error)")
                }
            }
        } catch let error {
            print(error)
        }
    }

    public func loadUIData() -> [[UIData]] {
        var loadedUIData = [[UIData]]()

        var jsonStr = String()

        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileName = "uiData.json"
            let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent(fileName)

            do {
                jsonStr = try String(contentsOf: targetTextFilePath, encoding: String.Encoding.utf8)
            } catch let error {
                print(error)
            }
        }

        let jsonData = jsonStr.data(using: .utf8)

        loadedUIData = try! JSONDecoder().decode([[UIData]].self, from: jsonData!)

        return loadedUIData
    }

}