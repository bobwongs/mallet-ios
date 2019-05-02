//
//  RunApp.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/22.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

@objcMembers
class RunApp: UIViewController {

    @IBOutlet weak var appView: UIView!

    public var codeStr = ""
    public var uiDataStr = ""

    public var code: [String] = [String]()

    public var appUI: Dictionary<Int, UIView> = Dictionary()

    public var numberGlobalVariableAddress: Dictionary<String, Int> = Dictionary();
    public var stringGlobalVariableAddress: Dictionary<String, Int> = Dictionary();

    public var numberGlobalVariable: [Int] = [Int](repeating: 0, count: 100000)
    public var stringGlobalVariable: [String] = [String](repeating: "", count: 1000)

    private let objCpp = ObjCpp()

    override func viewDidLoad() {
        super.viewDidLoad()

        numberGlobalVariableAddress["a"] = 1
        numberGlobalVariableAddress["b"] = 2

        stringGlobalVariableAddress["globStr"] = 1

        GenerateAppScreen()

        InitRunner()
    }

    private func GenerateAppScreen() {
        let uiData = ScreenDataController().stringToUIData(jsonStr: uiDataStr)

        let stackView = ScreenGenerator().generateScreen(inputUIData: uiData)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: appView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: appView.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: appView.topAnchor, constant: 30).isActive = true
    }

    public func SetUIText(id: Int, text: String) {
        let runApp = topViewController() as! RunApp

        let typeOfUI = type(of: runApp.appUI[id]!)

        if typeOfUI == AppButton.self {
            let button = runApp.appUI[id] as! UIButton
            button.setTitle(text, for: .normal)
        }
        if typeOfUI == AppLabel.self {
            let label = runApp.appUI[id] as! UILabel
            label.text = text
        }
    }

    public func SetNumberGlobalVariable(address: Int, value: Int) {
        let runApp = topViewController() as! RunApp

        runApp.numberGlobalVariable[address] = value
    }

    public func GetNumberGlobalVariable(address: Int) -> Int {
        let runApp = topViewController() as! RunApp

        return runApp.numberGlobalVariable[address]
    }

    public func SetStringGlobalVariable(address: Int, value: String) {
        let runApp = topViewController() as! RunApp

        runApp.stringGlobalVariable[address] = value
    }

    public func GetStringGlobalVariable(address: Int) -> String {
    let runApp = topViewController() as! RunApp

return runApp.stringGlobalVariable[address]
}

private func InitRunner() {
    var jsons: Array<String> = Array<String>()

    for i in code {
        let json = objCpp.convertCode(toJson: i, numberGlobalVariableAddress, stringGlobalVariableAddress)
        jsons.append(json!)
    }

    objCpp.extractCodes(jsons)
}

    public func RunCode(id: Int) {
        objCpp.runCode(Int32(id))
    }

    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
