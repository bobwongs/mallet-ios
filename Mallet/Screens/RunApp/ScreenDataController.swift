//
//  ScreenDataController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

/*
public struct UIData_: Codable {
    let uiID: Int?
    let text: String?
    let value: Int?

    init(uiID: Int, text: String, value: Int) {
        self.uiID = uiID
        self.text = text
        self.value = value
    }
}
*/

public struct UIData: Codable {
    let uiID: Int?
    var uiName: String?
    let uiType: Int?
    var text: String?
    var value: Int?
    var x: CGFloat?
    var y: CGFloat?

    init(uiID: Int, uiName: String, uiType: Int, text: String, value: Int, x: CGFloat, y: CGFloat) {
        self.uiID = uiID
        self.uiName = uiName
        self.uiType = uiType
        self.text = text
        self.value = value
        self.x = x
        self.y = y
    }
}

public class ScreenDataController {

    public func generateRandomUIData() -> [UIData] {

        let uiNum = Int.random(in: 5...10)

        var randomUIData = [UIData]()

        for i in 0..<uiNum {
            let uiID = i
            let uiName = "UI" + String(uiID)
            let uiType = Int.random(in: 0..<2)
            let text = "Text"
            let value = 0
            let x = CGFloat(Int.random(in: 0..<100))
            let y = CGFloat(Int.random(in: 0..<100))

            let uiData = UIData(uiID: uiID, uiName: uiName, uiType: uiType, text: text, value: value, x: x, y: y)

            randomUIData.append(uiData)
        }

        /*
        for i in 0..<2 {
            randomUIData.append([UIData]())
            for _ in 2...4 {
                let uiID = Int.random(in: 0..<3)
                let text = "Text"
                let value = 0
                let uiData = UIData_(uiID: uiID, text: text, value: value)

                randomUIData[i].append(uiData)
            }
        }

        print(randomUIData)
        */

        return randomUIData
    }

    public func generateTestUIData() -> [UIData] {
        var testUIData = [UIData]()

        testUIData.append(generateButtonUIData())
        testUIData.append(generateTextLabelUIData())

        print(testUIData)

        return testUIData
    }

    private func generateButtonUIData() -> UIData {
        return UIData(uiID: 0, uiName: "Button1", uiType: 0, text: "ButtonButton", value: 0, x: 200, y: 100)
    }

    private func generateTextLabelUIData() -> UIData {
        return UIData(uiID: 1, uiName: "Label1", uiType: 1, text: "Label", value: 0, x: 200, y: 300)
    }

    public func saveUIData(saveData: [UIData]) {
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

    public func loadUIData() -> [UIData] {
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

        return stringToUIData(jsonStr: jsonStr)
    }

    public func uiDataToString(uiData: [UIData]) -> String {
        do {
            let jsonData = try JSONEncoder().encode(uiData)
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!

            return jsonStr
        } catch let error {
            print(error)
            return ""
        }
    }

    public func stringToUIData(jsonStr: String) -> [UIData] {
        let jsonData = jsonStr.data(using: .utf8)

        let loadedUIData = try! JSONDecoder().decode([UIData].self, from: jsonData!)

        return loadedUIData
    }

}