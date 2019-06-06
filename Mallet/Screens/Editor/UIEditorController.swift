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
    var uiName: String?
    let uiType: Int?
    var text: String?
    var value: Int?
    var x: Float?
    var y: Float?

    init(uiID: Int, uiName: String, uiType: Int, text: String, value: Int, x: Float, y: Float) {
        self.uiID = uiID
        self.uiName = uiName
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

    @IBOutlet weak var UINameTextField: UITextField!
    @IBOutlet weak var UITextTextField: UITextField!

    var appScreen: UIView = UIView()

    var UIDic: Dictionary<Int, UIData> = Dictionary<Int, UIData>()
    var UINum: Int = 0
    var selectedUIID: Int = 0

    var uiScale: CGFloat = 0.7

    let uiTypeNum = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        initUIEditor()
    }

    func initUIEditor() {
        let screenSize = editorView.bounds.size
        appScreen = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * uiScale, height: screenSize.height * uiScale))
        appScreen.center = appScreenParent.center
        appScreen.backgroundColor = UIColor.white
        appScreen.layer.borderColor = UIColor.lightGray.cgColor
        appScreen.layer.borderWidth = 1

        appScreenParent.addSubview(appScreen)

        uiTable.delegate = self
        uiTable.dataSource = self

        UINameTextField.text = ""
        UITextTextField.text = ""

        UINameTextField.addTarget(self, action: #selector(self.setUIName), for: .editingChanged)
        UITextTextField.addTarget(self, action: #selector(self.setUIText), for: .editingChanged)

        UINum = 0
        selectedUIID = -1
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

                        ui.isUserInteractionEnabled = true
                        let tap: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
                        tap.delegate = self
                        ui.addGestureRecognizer(tap)

                        let uiName = "UI" + String(UINum)
                        let uiText = "Text"
                        let uiX = Float(senderView.frame.origin.x)
                        let uiY = Float(senderView.frame.origin.y)
                        let uiData = UIData(uiID: UINum, uiName: uiName, uiType: uiType, text: uiText, value: 0, x: uiX, y: uiY)
                        UIDic[UINum] = uiData
                        UINum += 1

                        var appSampleUIData = senderView as! AppSampleUIData
                        appSampleUIData.uiID = uiData.uiID ?? 0
                    }

                    senderView.translatesAutoresizingMaskIntoConstraints = true

                    let center = senderView.superview?.convert(senderView.center, to: editorView)

                    editorView.addSubview(senderView)
                    senderView.center = center ?? CGPoint()
                }

                let uiID = (senderView as! AppSampleUIData).uiID
                UINameTextField.text = UIDic[uiID]?.uiName
                UITextTextField.text = UIDic[uiID]?.text

                selectedUIID = uiID
            }
        }

        let move = sender.translation(in: self.view)
        sender.view?.center.x += move.x
        sender.view?.center.y += move.y

        sender.setTranslation(CGPoint.zero, in: self.view)
    }

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

    @objc func setUIName(textField: UITextField) {
        if selectedUIID < 0 {
            return
        }

        UIDic[selectedUIID]?.uiName = textField.text
    }


    @objc func setUIText(textField: UITextField) {
        if selectedUIID < 0 {
            return
        }

        UIDic[selectedUIID]?.text = textField.text
    }
}
