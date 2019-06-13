//
//  UIEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UIEditorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var Editor: EditorController = EditorController()

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var uiTable: UITableView!
    @IBOutlet weak var appScreenParent: UIView!

    @IBOutlet weak var UINameTextField: UITextField!
    @IBOutlet weak var UITextTextField: UITextField!

    var appScreen: UIView = UIView()

    var UIDic: Dictionary<Int, UIData> = Dictionary<Int, UIData>()
    var UIViewDic: Dictionary<Int, UIView> = Dictionary<Int, UIView>()
    var UINum: Int = 0
    var selectedUIID: Int = 0

    var uiScale: CGFloat = 0.7

    let uiTypeNum = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        initUIEditor()

        generateScreen()
    }

    func initUIEditor() {
        var screenSize = UIScreen.main.bounds.size
        if let navigationController = navigationController {
            screenSize.height -= navigationController.navigationBar.frame.size.height
        }

        appScreen = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width * uiScale, height: screenSize.height * uiScale))
        appScreen.center = appScreenParent.center
        appScreenParent.addSubview(appScreen)

        appScreen.translatesAutoresizingMaskIntoConstraints = false
        appScreen.centerXAnchor.constraint(equalTo: appScreenParent.centerXAnchor).isActive = true
        appScreen.centerYAnchor.constraint(equalTo: appScreenParent.centerYAnchor).isActive = true
        appScreen.widthAnchor.constraint(equalToConstant: screenSize.width * uiScale).isActive = true
        appScreen.heightAnchor.constraint(equalToConstant: screenSize.height * uiScale).isActive = true

        appScreen.backgroundColor = UIColor.white
        appScreen.layer.borderColor = UIColor.lightGray.cgColor
        appScreen.layer.borderWidth = 1

        uiTable.delegate = self
        uiTable.dataSource = self

        UINameTextField.text = ""
        UITextTextField.text = ""

        UINameTextField.addTarget(self, action: #selector(self.setUIName), for: .editingChanged)
        UITextTextField.addTarget(self, action: #selector(self.setUIText), for: .editingChanged)

        //UINum = 0
        selectedUIID = -1
    }

    func generateScreen() {
        for uiDic in UIDic {
            let ui = generateSampleUI(uiType: uiDic.value.uiType ?? 0)
            appScreen.addSubview(ui)

            ui.center.x = uiDic.value.x! * uiScale
            ui.center.y = uiDic.value.y! * uiScale

            ui.isUserInteractionEnabled = true

            let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
            pan.delegate = self
            ui.addGestureRecognizer(pan)

            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapUI(_:)))
            tap.delegate = self
            ui.addGestureRecognizer(tap)

            UIViewDic[uiDic.value.uiID!] = ui

            switch uiDic.value.uiType! {
            case 0:
                let label = ui as! UILabel
                label.text = uiDic.value.text!
            case 1:
                let button = ui as! UIButton
                button.setTitle(uiDic.value.text, for: .normal)
            default:
                break
            }

            ui.sizeToFit()
        }
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

        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
        pan.delegate = self
        ui.addGestureRecognizer(pan)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapUI(_:)))
        tap.delegate = self
        ui.addGestureRecognizer(tap)

        return cell
    }

    @objc func tapUI(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }

        let appSampleUIData = senderView as! AppSampleUIData

        let uiID = appSampleUIData.uiID
        UINameTextField.text = UIDic[uiID]?.uiName
        UITextTextField.text = UIDic[uiID]?.text

        selectedUIID = uiID
    }

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }

        var appSampleUIData = senderView as! AppSampleUIData

        if sender.state == .began {
            guard let superView = senderView.superview else {
                return
            }

            if superView != appScreen {
                //画面にUIを追加

                let uiType = appSampleUIData.uiType
                let uiOnTable = generateSampleUI(uiType: uiType)
                uiOnTable.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
                superView.addSubview(uiOnTable)

                uiOnTable.translatesAutoresizingMaskIntoConstraints = false
                uiOnTable.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
                uiOnTable.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true

                uiOnTable.isUserInteractionEnabled = true

                let pan = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
                pan.delegate = self
                uiOnTable.addGestureRecognizer(pan)

                let tap = UITapGestureRecognizer(target: self, action: #selector(tapUI(_:)))
                tap.delegate = self
                uiOnTable.addGestureRecognizer(tap)

                let uiName = "UI" + String(UINum)
                let uiText = "Text"
                let uiX = senderView.center.x / uiScale
                let uiY = senderView.center.y / uiScale
                let uiData = UIData(uiID: UINum, uiName: uiName, uiType: uiType, text: uiText, value: 0, x: uiX, y: uiY)
                UIDic[UINum] = uiData

                appSampleUIData.uiID = UINum
                UINum += 1

                senderView.translatesAutoresizingMaskIntoConstraints = true

                let center = senderView.superview?.convert(senderView.center, to: appScreen)
                appScreen.addSubview(senderView)
                senderView.center = center ?? CGPoint()

                UIViewDic[appSampleUIData.uiID] = senderView

                switch uiType {
                case 0:
                    let label = senderView as! UILabel
                    label.text = uiText
                case 1:
                    let button = senderView as! UIButton
                    button.setTitle(uiText, for: .normal)
                default:
                    break
                }

                senderView.sizeToFit()
            }

            let uiID = appSampleUIData.uiID
            UINameTextField.text = UIDic[uiID]?.uiName
            UITextTextField.text = UIDic[uiID]?.text

            selectedUIID = uiID
        }

        if sender.state == .ended {
            let uiID = appSampleUIData.uiID

            let uiX = senderView.center.x / uiScale
            let uiY = senderView.center.y / uiScale

            UIDic[uiID]?.x = uiX
            UIDic[uiID]?.y = uiY

            saveScreen()
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

        saveScreen()
    }


    @objc func setUIText(textField: UITextField) {
        if selectedUIID < 0 {
            return
        }

        UIDic[selectedUIID]?.text = textField.text

        switch UIDic[selectedUIID]?.uiType {
        case 0:
            let label = UIViewDic[selectedUIID] as! UILabel
            label.text = textField.text
        case 1:
            let button = UIViewDic[selectedUIID] as! UIButton
            button.setTitle(textField.text, for: .normal)
        default:
            break
        }

        UIViewDic[selectedUIID]?.sizeToFit()

        saveScreen()
    }

    func saveScreen() {
        Editor.screenData.removeAll()

        for i in 0..<UINum {
            if let uiData = UIDic[i] {
                Editor.screenData.append(uiData)
            }
        }
    }

}
