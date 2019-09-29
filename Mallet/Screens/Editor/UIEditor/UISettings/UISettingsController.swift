//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UITextFieldDelegate {

    @IBOutlet weak var settingsTableView: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        navigationBar.delegate = self
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        return cell
    }

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
