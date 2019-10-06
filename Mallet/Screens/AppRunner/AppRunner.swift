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

        navigationItem.title = appData.appName

        GenerateAppScreen()

        print(appData.code)

        CloudVariableController.startApp(appRunner: self)

        if let appID = self.appData?.appID {
            runner.initRunner(appData.code, AppDatabaseController.getAppVariablesDictionary(appID: appID))
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

    func updateCloudVariables(variables: [AppVariable]) {
        for variable in variables {
            if runner.updateCloudVariable(variable.name, variable.value) {
                for (_, ui) in self.appUI {
                    if ui.cloudVariableName == variable.name {
                        ui.updateTextWithCloudVariable(value: variable.value)
                    }
                }
            }
        }
    }

    func quitApp() {
        CloudVariableController.endApp()
        runner.terminateRunner()
    }

    func navigationController(_: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        if !(viewController is AppRunner) {
            quitApp()
        }
    }
}
