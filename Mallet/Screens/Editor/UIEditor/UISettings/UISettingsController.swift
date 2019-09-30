//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate {

    public var ui: EditorUI?

    public var uiData: UIData?

    @IBOutlet weak var settingsTableView: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        navigationBar.delegate = self

        if let uiData = uiData {
            print("Yay!")

            uiData.labelData?.text = "Yay!"

            ui?.reload(uiData: uiData)
        }
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }

        return "Label"
    }

/*
func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 10
}
*/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
