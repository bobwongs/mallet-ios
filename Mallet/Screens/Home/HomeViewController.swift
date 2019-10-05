//
//  ViewController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AppCellDelegate {

    @IBOutlet weak var appTableView: UITableView!

    var appList: [(Int, String)]!

    override func viewDidLoad() {
        super.viewDidLoad()

        appTableView.delegate = self
        appTableView.dataSource = self
        appTableView.register(UINib(nibName: "AppCell", bundle: nil), forCellReuseIdentifier: "AppCell")

        reloadAppTableView()
    }

    func reloadAppTableView() {
        appList = AppDatabaseController.getAppList()

        appTableView.reloadData()
    }

    func editApp(appID: Int) {
        let storyboard = UIStoryboard(name: "UIEditor", bundle: nil)
        guard let uiEditorController = storyboard.instantiateInitialViewController() as? UIEditorController else {
            fatalError()
        }

        let appData = AppDatabaseController.getApp(appID: appID)

        uiEditorController.appData = appData

        navigationController?.pushViewController(uiEditorController, animated: true)
    }

    func runApp(appID: Int) {
        self.runApp(appID: appID, animated: true)
    }

    func runApp(appID: Int, animated: Bool) {
        let storyboard = UIStoryboard(name: "AppRunner", bundle: nil)

        guard let appRunner = storyboard.instantiateInitialViewController() as? AppRunner else {
            fatalError()
        }

        appRunner.appData = AppDatabaseController.getApp(appID: appID)

        navigationController?.pushViewController(appRunner, animated: animated)
    }

    @IBAction func addAppButton(_ sender: Any) {
        let appData = AppDatabaseController.createNewApp()

        editApp(appID: appData.appID)
    }

    @IBAction func removeAllButton(_ sender: Any) {
        AppDatabaseController.removeAllApp()

        reloadAppTableView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDatabaseController.removeApp(appID: appList[indexPath.row].0)
            appList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = appTableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath) as? AppCell else {
            fatalError()
        }

        let appID = appList[indexPath.row].0
        let appTitle = appList[indexPath.row].1

        cell.setCell(homeViewController: self, appID: appID, appTitle: appTitle)

        return cell
    }
}

