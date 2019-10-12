//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsModal: UIViewController, UINavigationBarDelegate {

    public var ui: EditorUI?

    public var uiData: UIData?

    public var uiSettingsDelegate: UISettingsDelegate?

    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var navigationBarItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.delegate = self

        navigationBarItem.title = ui?.uiName


        if let ui = self.ui, let uiData = self.uiData, let uiSettingsDelegate = self.uiSettingsDelegate {

            let uiSettingsController: UISettingsController!

            switch uiData.uiType {
            case .Label:
                uiSettingsController = LabelUISettingsController(ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate)

            case .Button:
                uiSettingsController = ButtonUISettingsController(ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate)

            case .Table:
                uiSettingsController = TableUISettingsController(ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate)

            default:
                uiSettingsController = UISettingsController(ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate)
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
