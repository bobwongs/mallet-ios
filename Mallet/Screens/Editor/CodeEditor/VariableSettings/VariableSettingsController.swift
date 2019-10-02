//
//  VariableSettingsControllerTableViewController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VariableSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {

    @IBOutlet weak var variableTableView: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!

    var list = [1, 1, 4, 5, 1, 4, 1, 9, 1, 9]

    override func viewDidLoad() {
        super.viewDidLoad()

        variableTableView.delegate = self
        variableTableView.dataSource = self

        navigationBar.delegate = self
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VariableSettingsCell(reuseIdentifier: "Cell")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

struct AppVariable {
    var address: Int
    var name: String
    var value: String

    init(address: Int, name: String, value: String) {
        self.address = address
        self.name = name
        self.value = value
    }
}