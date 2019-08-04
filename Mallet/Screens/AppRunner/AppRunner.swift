//
//  AppRunner.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/22.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

@objcMembers
class AppRunner: UIViewController {

    @IBOutlet weak var appView: UIView!

    public var appData: String?

    public var codeStr: String?
    public var uiData: [UIData]?

    public var uiName = Dictionary<String, Int>()

    public var appUI: Dictionary<Int, UIView> = Dictionary()

    private let runner = RunnerObjCpp()

    override func viewDidLoad() {
        super.viewDidLoad()

        InitRunner()
    }

    private func GenerateAppScreen() {

        guard let uiData = uiData else {
            fatalError()
        }

        ScreenGenerator().generateScreen(inputUIData: uiData, appView: appView)
    }

    public func SetUIText(id: Int, text: String) {
        let appRunner = topViewController() as! AppRunner

        let typeOfUI = type(of: appRunner.appUI[id]!)

        if typeOfUI == AppButton.self {
            let button = appRunner.appUI[id] as! UIButton
            button.setTitle(text, for: .normal)
            button.sizeToFit()
        }
        if typeOfUI == AppLabel.self {
            let label = appRunner.appUI[id] as! UILabel
            label.text = text
            label.sizeToFit()
        }
    }

    private func InitRunner() {
        guard let appData = appData else {
            print("appData is nil")
            fatalError()
        }

        guard let jsonData = appData.data(using: .utf8) else {
            fatalError()
        }

        do {
            let decodedAppData = try JSONDecoder().decode(AppData.self, from: jsonData)

            uiData = decodedAppData.uiData
            codeStr = decodedAppData.code
        } catch let error {
            print(error)
        }

        guard  let codeStr = codeStr else {
            fatalError()
        }

        GenerateAppScreen()

        runner.initRunner(codeStr)
    }

    public func RunCode(id: Int) {
        runner.runCode(Int32(id))
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
}
