//
//  UIEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public struct UIData: Codable {
    let uiID: Int?
    let uiType: Int?
    let text: String?
    let value: Int?
    let x: Float?
    let y: Float?

    init(uiID: Int, uiType: Int, text: String, value: Int, x: Float, y: Float) {
        self.uiID = uiID
        self.uiType = uiType
        self.text = text
        self.value = value
        self.x = x
        self.y = y
    }
}

class UIEditorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var uiTable: UITableView!
    @IBOutlet weak var appScreenParent: UIView!

    var appScreen: UIView = UIView()

    var UIDic: Dictionary<Int, UIData> = Dictionary<Int, UIData>()

    var uiScale: CGFloat = 0.7

    let uiTypeNum = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = editorView.bounds.size
        appScreen = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * uiScale, height: screenSize.height * uiScale))
        appScreen.center = appScreenParent.center
        appScreen.backgroundColor = UIColor.white
        appScreen.layer.borderColor = UIColor.lightGray.cgColor
        appScreen.layer.borderWidth = 1

        appScreenParent.addSubview(appScreen)

        uiTable.delegate = self
        uiTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiTypeNum
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        let ui = generateSampleUI(uiType: indexPath.row)
        cell.addSubview(ui)

        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        ui.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

        ui.isUserInteractionEnabled = true
        let tap: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
        tap.delegate = self
        ui.addGestureRecognizer(tap)

        return cell
    }


    /*
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if (indexPath.row != 1) {
            return
        }

        let button = AppSampleUIButton()

        button.tag = 1
        button.isUserInteractionEnabled = true
        button.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
        let cellPoint = tableView.cellForRow(at: indexPath)?.center ?? CGPoint()
        button.center = CGPoint(x: tableView.frame.origin.x + cellPoint.x, y: tableView.frame.origin.y + cellPoint.y)


        let tap: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
        tap.delegate = self
        button.addGestureRecognizer(tap)

        editorView.addSubview(button)
    }
    */

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if let senderView = sender.view {
                if senderView.superview != editorView {
                    if let superView = senderView.superview {
                        let uiType = (senderView as! AppSampleUIData).uiType
                        let ui = generateSampleUI(uiType: uiType)
                        ui.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
                        superView.addSubview(ui)

                        ui.translatesAutoresizingMaskIntoConstraints = false
                        ui.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
                        ui.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true

                        ui.isUserInteractionEnabled = true
                        let tap: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
                        tap.delegate = self
                        ui.addGestureRecognizer(tap)
                    }


                    senderView.translatesAutoresizingMaskIntoConstraints = true

                    let center = senderView.superview?.convert(senderView.center, to: editorView)

                    editorView.addSubview(senderView)
                    senderView.center = center ?? CGPoint()
                }
            }
        }

        let move = sender.translation(in: self.view)
        sender.view?.center.x += move.x
        sender.view?.center.y += move.y

        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    /*
    func initUIList() {
        let uiLabel = AppSampleUILabel()

        let uiButton = AppSampleUIButton()

        let uiSwitch = AppSampleUISwitch()
        uiSwitch.isOn = true

        uiList.append(uiLabel)
        uiList.append(uiButton)
        uiList.append(uiSwitch)

        for i in uiList {
            i.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
        }

    }
    */

    func generateSampleUI(uiType: Int) -> UIView {
        var ui: UIView = UIView()

        switch uiType {
        case 0:
            ui = AppSampleUILabel()
        case 1:
            ui = AppSampleUIButton()
        case 2:
            ui = AppSampleUISwitch()
            (ui as! AppSampleUISwitch).isOn = true
        default:
            break
        }

        ui.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)

        return ui
    }
}