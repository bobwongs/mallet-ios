//
//  UIEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UIEditorController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var uiTable: UITableView!
    @IBOutlet weak var appScreenParent: UIView!

    var appScreen: UIView = UIView()

    var uiList: Array<UIView> = Array<UIView>()

    var uiScale: CGFloat = 0.7

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = editorView.bounds.size //UIScreen.main.bounds.size
        appScreen = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * uiScale, height: screenSize.height * uiScale))
        appScreen.center = appScreenParent.center
        appScreen.backgroundColor = UIColor.white
        appScreen.layer.borderColor = UIColor.lightGray.cgColor
        appScreen.layer.borderWidth = 1
        appScreenParent.addSubview(appScreen)

        uiTable.delegate = self
        uiTable.dataSource = self

        initUIList()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let ui = uiList[indexPath.row]

        cell.addSubview(ui)

        ui.isUserInteractionEnabled = false
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        ui.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != 1) {
            return
        }

        let button = AppSampleUIButton()

        button.tag = 1
        button.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
        let cellPoint = tableView.cellForRow(at: indexPath)?.center ?? CGPoint()
        button.center = CGPoint(x: tableView.frame.origin.x + cellPoint.x, y: tableView.frame.origin.y + cellPoint.y)

        editorView.addSubview(button)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let touchedView = touch.view {
                if touchedView.tag == 1 {
                    touchedView.center = touch.location(in: view)
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBegan(touches, with: event)
    }

    func initUIList() {
        let uiLabel = AppUILabel()

        let uiButton = AppUIButton()

        let uiSwitch = AppUISwitch()
        uiSwitch.isOn = true

        uiList.append(uiLabel)
        uiList.append(uiButton)
        uiList.append(uiSwitch)

        for i in uiList {
            i.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
        }

    }

}
