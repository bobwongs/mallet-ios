//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsController: UIViewController, UINavigationBarDelegate {

    public var ui: EditorUI?

    public var uiData: UIData?

    public var delegate: UISettingsDelegate?

    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var navigationBarItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.delegate = self

        navigationBarItem.title = ui?.uiName

        if let ui = self.ui, let uiData = self.uiData {
            let settingsTableView: DefaultUISettingsTableView!
            switch uiData.uiType {
            case .Label:
                settingsTableView = LabelUISettingsTableView(frame: CGRect(), ui: ui, uiData: uiData, uiSettingsController: self)

            case .Button:
                settingsTableView = ButtonUISettingsTableView(frame: CGRect(), ui: ui, uiData: uiData, uiSettingsController: self)

            default:
                settingsTableView = DefaultUISettingsTableView(frame: CGRect(), ui: ui, uiData: uiData, uiSettingsController: self)
            }

            self.view.addSubview(settingsTableView)

            settingsTableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                    [
                        settingsTableView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
                        settingsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        settingsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                        settingsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
                    ]
            )
        }
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

public protocol UISettingsDelegate {
    func saveApp()
}