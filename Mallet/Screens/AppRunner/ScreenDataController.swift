//
//  ScreenDataController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/23.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public class UIData: Codable {
    var uiID: Int
    let uiType: UIType
    var uiName: String
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat

    var labelData: LabelUIData?
    var buttonData: ButtonUIData?
    var textFieldData: TextFieldUIData?
    var switchData: SwitchUIData?
    var sliderData: SliderUIData?
    var tableData: tableUIData?

    init(uiID: Int, uiName: String, uiType: UIType, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.uiID = uiID
        self.uiName = uiName
        self.uiType = uiType
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    static func TextUIAlignment2NSTextAlignment(alignment: TextUIAlignment) -> NSTextAlignment {
        switch alignment {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        }
    }

    func copy() -> UIData {
        return self.copy(uiID: self.uiID)
    }

    func copy(uiID: Int) -> UIData {
        let uiData = UIData(uiID: uiID, uiName: self.uiName, uiType: self.uiType, x: self.x, y: self.y, width: self.width, height: self.height)
        uiData.labelData = self.labelData
        uiData.buttonData = self.buttonData
        uiData.textFieldData = self.textFieldData
        uiData.switchData = self.switchData
        uiData.sliderData = self.sliderData
        uiData.tableData = self.tableData

        return uiData
    }
}

public struct LabelUIData: Codable {
    var text: String
    var fontSize: Int
    var fontColor: String
    var alignment: TextUIAlignment


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
    var text: String
    var fontSize: Int
    var fontColor: String
    var backgroundColor: String

    var code: [CodeType: funcData]

    init(text: String, fontSize: Int, fontColor: String, backgroundColor: String, code: [CodeType: funcData]) {
        self.text = text
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.backgroundColor = backgroundColor

        self.code = code
    }

    init() {
        self.text = "Button"
        self.fontSize = 17
        self.fontColor = Color.defaultButtonLabelColor.hexString()
        self.backgroundColor = Color.defaultButtonColor.hexString()

        self.code = [CodeType.OnTap: funcData()]
    }

    enum CodeType: Int, Codable, CaseIterable {
        case OnTap
    }
}


public struct TextFieldUIData: Codable {
    var text: String
    var fontSize: Int
    var fontColor: String
    var alignment: TextUIAlignment

    var code: [CodeType: funcData]

    init(text: String, fontSize: Int, fontColor: String, alignment: TextUIAlignment, code: [CodeType: funcData]) {
        self.text = text
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.alignment = alignment

        self.code = code
    }

    init() {
        self.text = "Input"
        self.fontSize = 17
        self.fontColor = Color.defaultLabelColor.hexString()
        self.alignment = .left

        self.code = [CodeType.OnChange: funcData()]
    }

    enum CodeType: Int, Codable, CaseIterable {
        case OnChange
    }
}

public struct SwitchUIData: Codable {
    var value: Int

    var code: [CodeType: funcData]

    init(value: Int, code: [CodeType: funcData]) {
        self.value = value

        self.code = code
    }

    init() {
        self.value = 1

        self.code = [CodeType.OnChange: funcData()]
    }

    enum CodeType: Int, Codable, CaseIterable {
        case OnChange
    }
}


public struct SliderUIData: Codable {
    var value: Float
    var max: Float
    var min: Float

    var code: [CodeType: funcData]

    init(value: Float, max: Float, min: Float, code: [CodeType: funcData]) {
        self.value = value
        self.max = max
        self.min = min

        self.code = code
    }

    init() {
        self.value = 0.5
        self.max = 1
        self.min = 0

        self.code = [CodeType.OnChange: funcData(), CodeType.OnStart: funcData(), CodeType.OnEnd: funcData()]
    }

    enum CodeType: Int, Codable, CaseIterable {
        case OnStart
        case OnChange
        case OnEnd
    }
}

public struct tableUIData: Codable {
    var value: [String]

    var isCloud: Bool
    var isPersistent: Bool

    init(value: [String], isCloud: Bool, isPersistent: Bool) {
        self.value = value
        self.isCloud = isCloud
        self.isPersistent = isPersistent
    }

    init() {
        self.value = []
        self.isCloud = false
        self.isPersistent = false
    }
}

public struct funcData: Codable {
    var funcID: Int
    var code: String

    init(id: Int, code: String) {
        self.funcID = id
        self.code = code
    }

    init() {
        self.funcID = -1
        self.code = ""
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
