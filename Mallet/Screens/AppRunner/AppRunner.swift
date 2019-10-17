//
//  AppRunner.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/22.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppRunner: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var appView: UIView!

    var appData: AppData?

    var appUI: Dictionary<Int, AppUI> = Dictionary()

    private let runner = RunnerObjCpp()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self

        InitRunner()
    }

    private func InitRunner() {
        guard let appData = self.appData else {
            print("appData is nil")
            fatalError()
        }

        if #available(iOS 13, *) {
            self.overrideUserInterfaceStyle = .light
            self.navigationController?.overrideUserInterfaceStyle = .light
        }

        navigationItem.title = appData.appName

        if #available(iOS 13, *) {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(quitApp))
            navigationItem.leftBarButtonItem = closeButton
        } else {
            let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(quitApp))
            navigationItem.leftBarButtonItem = closeButton
        }

        GenerateAppScreen()

        print(appData.bytecode)

        CloudVariableController.startApp(appRunner: self)

        if let appID = self.appData?.appID {
            runner.initRunner(appData.bytecode, AppDatabaseController.getAppVariablesDictionary(appID: appID))
        }
    }

    private func GenerateAppScreen() {
        guard let uiData = appData?.uiData else {
            fatalError()
        }

        ScreenGenerator().generateScreen(appRunner: self, inputUIData: uiData, appView: appView)
    }

    func CallFunc(id: Int) {
        runner.runCode(Int32(id))
    }

    static func topAppRunner(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> AppRunner? {
        if let navigationController = controller as? UINavigationController {
            return topAppRunner(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topAppRunner(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topAppRunner(controller: presented)
        }
        return controller as? AppRunner
    }

    func updateCloudVariables(variables: [String: Any]) {
        for variable in variables {
            if let stringValue = variable.value as? String {
                runner.updateCloudVariable(variable.key, stringValue)
            }

            if let arrayValue = variable.value as? [String] {
                var array = NSMutableArray()
                for element in arrayValue {
                    array.add(element.suffix(element.count - CloudVariableController.randomPrefixLength))
                }

                runner.updateCloudList(variable.key, array)
            }
        }
    }

    @objc func quitApp() {
        CloudVariableController.endApp()

        runner.terminateRunner()

        self.dismiss(animated: true)
    }
}
