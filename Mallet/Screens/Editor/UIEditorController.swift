//
//  UIEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UIEditorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var uiTable: UITableView!
    @IBOutlet weak var appScreenParent: UIView!

    @IBOutlet weak var UINameTextField: UITextField!
    @IBOutlet weak var UITextTextField: UITextField!

    var appData: AppData!

    var appScreen: UIView = UIView()

    var uiData: [UIData]?

    var UIDictionary = Dictionary<Int, UIView>()
    var UINum = 0
    var selectedUIID = 0

    var uiScale: CGFloat = 0.7

    let uiTypeNum = UIType.allCases.count
    var UINumOfEachType = Dictionary<UIType, Int>()
    let uiTypeName = [UIType.Label: "Label",
                      UIType.Button: "Button",
                      UIType.Switch: "Switch"]

    override func viewDidLoad() {
        super.viewDidLoad()

        initUIEditor()

        generateScreen()
    }

    func initUIEditor() {
        setupView()

        selectedUIID = -1

        for type in UIType.allCases {
            UINumOfEachType[type] = 0
        }
    }

    func setupView() {
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

        UINameTextField.addTarget(self, action: #selector(self.setUINameToValueOfTextField), for: .editingChanged)
        UITextTextField.addTarget(self, action: #selector(self.setUITextToValueOfTextField), for: .editingChanged)
    }

    func generateScreen() {
        if let uiData = self.uiData {
            for uiData in uiData {

                let ui = generateEditorUI(uiType: uiData.uiType, uiID: uiData.uiID, uiName: uiData.uiName)
                appScreen.addSubview(ui)

                var appSampleUIData = ui as! EditorUIData
                appSampleUIData.uiID = uiData.uiID

                ui.center.x = uiData.x * uiScale
                ui.center.y = uiData.y * uiScale

                ui.isUserInteractionEnabled = true

                addGesture(ui: ui)

                setUIText(uiType: uiData.uiType, ui: ui, text: uiData.text)

                UINumOfEachType[uiData.uiType]! += 1
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiTypeNum
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        let uiType: UIType!
        switch indexPath.row {
        case 0:
            uiType = .Label
        case 1:
            uiType = .Button
        case 2:
            uiType = .Switch
        default:
            uiType = .Label
        }

        let ui = generateEditorUI(uiType: uiType, uiID: -1, uiName: "")
        cell.addSubview(ui)

        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        ui.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true

        ui.isUserInteractionEnabled = true

        addGesture(ui: ui)

        return cell
    }

    func addGesture(ui: UIView) {
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
        pan.delegate = self
        ui.addGestureRecognizer(pan)

        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToCode(_:)))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        ui.addGestureRecognizer(doubleTap)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectUI(_:)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.require(toFail: doubleTap)
        ui.addGestureRecognizer(tap)
    }

    @objc func moveToCode(_ sender: UILongPressGestureRecognizer) {
        if let senderSuperView = sender.view?.superview {
            if senderSuperView != appScreen {
                return
            }
        }

        let storyboard = UIStoryboard(name: "CodeEditor", bundle: nil)

        guard let controller = storyboard.instantiateInitialViewController() as? CodeEditorController else {
            fatalError()
        }

        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func selectUI(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }

        let uiData = senderView as! EditorUIData

        UINameTextField.text = uiData.uiName
        UITextTextField.text = getUIText(uiType: uiData.uiType, ui: senderView)

        selectedUIID = uiData.uiID
    }

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {
        guard let ui = sender.view else {
            return
        }

        var uiData = ui as! EditorUIData

        if sender.state == .began {
            guard let superView = ui.superview else {
                return
            }

            if superView != appScreen {
                //画面にUIを追加

                let uiType = uiData.uiType
                let uiOnTable = generateEditorUI(uiType: uiType, uiID: -1, uiName: "")
                uiOnTable.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
                superView.addSubview(uiOnTable)

                uiOnTable.translatesAutoresizingMaskIntoConstraints = false
                uiOnTable.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
                uiOnTable.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true

                uiOnTable.isUserInteractionEnabled = true

                addGesture(ui: uiOnTable)

                uiData.uiID = UINum
                UINum += 1
                UINumOfEachType[uiType]! += 1

                ui.translatesAutoresizingMaskIntoConstraints = true

                let center = ui.superview?.convert(ui.center, to: appScreen)
                appScreen.addSubview(ui)
                ui.center = center ?? CGPoint()

                let uiName = uiTypeName[uiType]! + String(UINumOfEachType[uiType]!)
                uiData.uiName = uiName

                UIDictionary[UINum] = ui
            }


            UINameTextField.text = (ui as! EditorUIData).uiName
            UITextTextField.text = getUIText(uiType: uiData.uiType, ui: ui)

            selectedUIID = uiData.uiID
        }

        let move = sender.translation(in: self.view)
        sender.view?.center.x += move.x
        sender.view?.center.y += move.y

        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    func generateEditorUI(uiType: UIType, uiID: Int, uiName: String) -> UIView {
        var ui: UIView!

        switch uiType {
        case .Label:
            ui = EditorUILabel(uiID: uiID, uiName: uiName)
        case .Button:
            ui = EditorUIButton(uiID: uiID, uiName: uiName)
        case .Switch:
            ui = EditorUISwitch(uiID: uiID, uiName: uiName)
            (ui as! EditorUISwitch).isOn = true
        }

        ui.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)

        return ui
    }

    @objc func setUINameToValueOfTextField(textField: UITextField) {
        if selectedUIID < 0 {
            return
        }

        var uiData = (UIDictionary[selectedUIID] as! EditorUIData)
        uiData.uiName = textField.text ?? ""
    }


    @objc func setUITextToValueOfTextField(textField: UITextField) {
        if selectedUIID < 0 {
            return
        }

        let uiData = UIDictionary[selectedUIID] as! EditorUIData

        setUIText(uiType: uiData.uiType, ui: UIDictionary[selectedUIID]!, text: UITextTextField.text ?? "")

        UIDictionary[selectedUIID]!.sizeToFit()
    }

    func setUIText(uiType: UIType, ui: UIView, text: String) {
        switch uiType {
        case .Label:
            let label = ui as! UILabel
            label.text = text

        case .Button:
            let button = ui as! UIButton
            button.setTitle(text, for: .normal)

        default:
            break
        }
    }

    func getUIText(uiType: UIType, ui: UIView) -> String {
        switch uiType {
        case .Label:
            let label = ui as! UILabel
            return label.text ?? ""

        case .Button:
            let button = ui as! UIButton
            return button.titleLabel?.text ?? ""

        default:
            return ""
        }
    }

}
