//
//  AppSettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/25.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppSettingsController: UIViewController, UINavigationBarDelegate {

    var uiEditorController: UIEditorController!

    var appSettingsTableViewController: AppSettingsTableViewController!

    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {

        super.viewDidLoad()

        navigationBar.delegate = self

        appSettingsTableViewController.appNameTextField.text = uiEditorController.appName
        appSettingsTableViewController.appSettingsController = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let appSettingsTableViewController = segue.destination as? AppSettingsTableViewController {
            self.appSettingsTableViewController = appSettingsTableViewController
        }
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    @IBAction func DoneButton(_ sender: Any) {
        uiEditorController.setAppName(appName: appSettingsTableViewController.appNameTextField.text)

        self.view.endEditing(true)

        self.dismiss(animated: true)
    }

    func save() {
        uiEditorController.setAppName(appName: appSettingsTableViewController.appNameTextField.text)

        uiEditorController.saveApp()
    }

    func addToHomeScreen() {
        uiEditorController.setAppName(appName: appSettingsTableViewController.appNameTextField.text)

        uiEditorController.addToHomeScreen()
    }
}

class AppSettingsTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var appNameTextField: UITextField!

    var appSettingsController: AppSettingsController!

    override func viewDidLoad() {
        super.viewDidLoad()

        appNameTextField.delegate = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)


        switch tableView.cellForRow(at: indexPath)?.reuseIdentifier ?? "" {
        case "save":
            appSettingsController.save()

        case "addToHomeScreen":
            appSettingsController.addToHomeScreen()

        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
