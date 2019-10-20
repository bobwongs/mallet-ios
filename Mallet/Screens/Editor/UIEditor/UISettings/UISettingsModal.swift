//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsModal: UIViewController, UINavigationBarDelegate {

    var appID: Int?

    var ui: EditorUI?

    var uiData: UIData?

    var uiSettingsDelegate: UISettingsDelegate?

    var codeEditorControllerDelegate: CodeEditorControllerDelegate?

    var editorDelegate: EditorDelegate?

    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var navigationBarItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.delegate = self

        navigationBarItem.title = ui?.uiData.uiName


        if let appID = appID, let ui = self.ui, let uiData = self.uiData, let uiSettingsDelegate = self.uiSettingsDelegate, let codeEditorControllerDelegate = self.codeEditorControllerDelegate, let editorDelegate = self.editorDelegate {

            let uiSettingsController: UISettingsController!

            switch uiData.uiType {
            case .Label:
                uiSettingsController = LabelUISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)

            case .Button:
                uiSettingsController = ButtonUISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)

            case .TextField:
                uiSettingsController = TextFieldUISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)

            case .Switch:
                uiSettingsController = SwitchUISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)

            case .Slider:
                uiSettingsController = SliderUISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)

            case .Table:
                uiSettingsController = TableUISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)

            default:
                uiSettingsController = UISettingsController(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate, editorDelegate: editorDelegate)
            }

            let childNavigation = UINavigationController(rootViewController: uiSettingsController)
            childNavigation.willMove(toParent: self)
            addChild(childNavigation)
            let frame = CGRect(x: 0, y: self.navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height - self.navigationBar.frame.height)
            childNavigation.view.frame = frame
            self.view.addSubview(childNavigation.view)
            childNavigation.didMove(toParent: self)
        }
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
