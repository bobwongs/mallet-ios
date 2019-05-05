//
//  UIEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UIEditorController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var appScreen: UIStackView!
    @IBOutlet weak var uiTable: UITableView!

    var uiList: Array<UIView> = Array<UIView>()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUIList()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let ui = uiList[indexPath.row]
        let wall = UIView()

        cell.addSubview(ui)

        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        ui.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

        if indexPath.row < 5 {
            cell.addSubview(wall)
            wall.translatesAutoresizingMaskIntoConstraints = false
            wall.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
            wall.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
            wall.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
            wall.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func initUIList() {
        let uiLabel = UILabel()
        uiLabel.text = "Text"

        let uiButton = UIButton()
        uiButton.setTitle("Button", for: .normal)
        uiButton.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 255 / 255, alpha: 1), for: .normal)

        let uiSwitch = UISwitch()
        uiSwitch.isOn = true

        uiList.append(uiLabel)
        uiList.append(uiButton)
        uiList.append(uiSwitch)
    }

}
