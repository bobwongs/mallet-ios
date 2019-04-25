//
//  ViewController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private let dataSource = AppInfoDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        let objcpp = ObjCpp()
        let code = "var str:String str=\"hoge\" print(str)"
        let json = objcpp.convertCode(toJson: code)

        print("From Swift : " + json!)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.appInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeViewCell else {
            fatalError()
        }
        let appInfo = dataSource.appInfo[(indexPath as NSIndexPath).row]
        cell.showCell(info: appInfo)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appInfo = dataSource.appInfo[(indexPath as NSIndexPath).row]


        let storyboard = UIStoryboard(name: "Editor", bundle: nil)
        guard let controller: UIViewController = storyboard.instantiateInitialViewController() else {
            fatalError()
        }


        navigationController?.pushViewController(controller, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}

