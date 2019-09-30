//
//  ScreenDataController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public class UIData: Codable {
    let uiID: Int
    let uiType: UIType
    let uiName: String
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat

    var labelData: LabelUIData?
    var buttonData: ButtonUIData?
    var textFieldData: TextFieldUIData?
    var switchData: SwitchUIData?
    var sliderData: SliderUIData?

    init(uiID: Int, uiName: String, uiType: UIType, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.uiID = uiID
        self.uiName = uiName
        self.uiType = uiType
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

public struct LabelUIData: Codable {
    let text: String
    let fontSize: Int
    let fontColor: String
    let alignment: TextUIAlignment

    init(text: String, fontSize: Int, fontColor: String, alignment: TextUIAlignment) {
        self.text = text
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.alignment = alignment
    }

    init() {
        self.text = "Label"
        self.fontSize = 20
        self.fontColor = Color.defaultLabelColor.hexString()
        self.alignment = .left
    }
}

public enum TextUIAlignment: Int, Codable {
    case left
    case center
    case right
}

public struct ButtonUIData: Codable {
    let text: String
    let fontSize: Int
    let fontColor: String

    let onTap: funcData

    init(text: String, fontSize: Int, fontColor: String, onTap: funcData) {
        self.text = text
        self.fontSize = fontSize
        self.fontColor = fontColor

        self.onTap = onTap
    }

    init() {
        self.text = "Button"
        self.fontSize = 17
        self.fontColor = Color.defaultButtonColor.hexString()

        self.onTap = funcData(id: -1, code: "")
    }
}

public struct TextFieldUIData: Codable {

}

public struct SwitchUIData: Codable {

}


public struct SliderUIData: Codable {

}

public struct funcData: Codable {
    let funcID: Int
    let code: String

    init(id: Int, code: String) {
        self.funcID = id
        self.code = code
    }
}

public class ScreenDataController {

    /*
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

        return randomUIData
    }
    */

    public func saveUIData(saveData: [UIData]) {
        do {
            let jsonData = try JSONEncoder().encode(saveData)
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            //print(jsonStr)

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
