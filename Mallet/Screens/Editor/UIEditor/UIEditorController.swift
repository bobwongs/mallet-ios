//
//  UIEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/05/05.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UIEditorController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, EditorUIDelegate, UISettingsDelegate, CodeEditorControllerDelegate {

    @IBOutlet var editorView: UIView!

    var uiTableModal: UIView!
    var uiTableModalPosY: NSLayoutConstraint!
    var uiCollection: UICollectionView!

    var appData: AppData!
    var appName: String!

    var appScreen: UIView = UIView()

    var uiData: [UIData]?

    var uiDictionary = Dictionary<Int, EditorUI>()
    var uiNum = 0
    var selectedUIID = 0

    var uiScale: CGFloat = 1

    let uiTypeNum = UIType.allCases.count
    var UINumOfEachType = Dictionary<UIType, Int>()
    let uiTypeName = [UIType.Label: "Label",
                      UIType.Button: "Button",
                      UIType.TextField: "TextField",
                      UIType.Switch: "Switch",
                      UIType.Slider: "Slider",
                      UIType.Table: "Table"]

    var initialCode = ""

    var globalVariablesCode = ""

    private var activityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self

        initUIEditor()

        initActivityIndicatorView()

        generateScreen()
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is HomeViewController {
            self.saveApp()

            (viewController as! HomeViewController).reloadAppTableView()
        }
    }

    func initUIEditor() {
        setupAppData()
        setupView()

        selectedUIID = -1

        for type in UIType.allCases {
            UINumOfEachType[type] = 0
        }
    }

    func initActivityIndicatorView() {
        self.activityIndicatorView.center = view.center
        //activityIndicatorView.accessibilityNavigationStyle = .automatic

        self.view.addSubview(self.activityIndicatorView)
    }

    func setupAppData() {
        appName = appData.appName
        globalVariablesCode = appData.globalVariableCode

        print(globalVariablesCode)
    }

    func setupView() {
        navigationItem.title = appData.appName

        var screenSize = UIScreen.main.bounds.size
        if let navigationController = navigationController {
            screenSize.height -= navigationController.navigationBar.frame.size.height
        }

        appScreen = UIView()
        self.view.addSubview(appScreen)
        appScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    appScreen.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                    appScreen.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    appScreen.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                    appScreen.rightAnchor.constraint(equalTo: self.view.rightAnchor)
                ]
        )

        appScreen.backgroundColor = UIColor.white

        generateUITableModal()

        uiCollection.delegate = self
        uiCollection.dataSource = self
    }

    func generateScreen() {
        uiNum = appData.uiData.count

        for uiData in appData.uiData {
            let ui = generateEditorUI(uiData: uiData)
            appScreen.addSubview(ui)

            ui.isUserInteractionEnabled = true

            addGesture(ui: ui)

            UINumOfEachType[uiData.uiType]! += 1
            uiDictionary[uiData.uiID] = ui
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uiTypeNum
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = Color.uiCollectionCellBackground
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Color.uiCollectionCellBorder.cgColor

        let uiData: UIData
        switch indexPath.row {
        case 0:
            uiData = UIData(uiID: -1, uiName: "", uiType: .Label, x: 0, y: 0, width: 80, height: 40)
            uiData.labelData = LabelUIData()

        case 1:
            uiData = UIData(uiID: -1, uiName: "", uiType: .Button, x: 0, y: 0, width: 70, height: 45)
            uiData.buttonData = ButtonUIData()

        case 2:
            uiData = UIData(uiID: -1, uiName: "", uiType: .TextField, x: 0, y: 0, width: 80, height: 40)
            uiData.textFieldData = TextFieldUIData()

        case 3:
            uiData = UIData(uiID: -1, uiName: "", uiType: .Switch, x: 0, y: 0, width: 80, height: 40)
            uiData.switchData = SwitchUIData()

        case 4:
            uiData = UIData(uiID: -1, uiName: "", uiType: .Slider, x: 0, y: 0, width: 80, height: 40)
            uiData.sliderData = SliderUIData()

        case 5:
            uiData = UIData(uiID: -1, uiName: "", uiType: .Table, x: 0, y: 0, width: 80, height: 60)
            uiData.tableData = tableUIData()

        default:
            uiData = UIData(uiID: -1, uiName: "", uiType: .Label, x: 0, y: 0, width: 800, height: 40)
            uiData.labelData = LabelUIData()

        }

        let ui = generateEditorUI(uiData: uiData)
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

        /*
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToCode(_:)))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        ui.addGestureRecognizer(doubleTap)
        */

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectUI(_:)))
        tap.delegate = self
        //tap.numberOfTapsRequired = 1
        //tap.require(toFail: doubleTap)
        ui.addGestureRecognizer(tap)
    }

    @objc func selectUI(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }

        guard let ui = senderView as? EditorUI else {
            fatalError("This is not UI")
        }

        selectedUIID = ui.uiData.uiID
    }

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {
        guard let ui = sender.view as? EditorUI else {
            fatalError("This is not UI")
        }

        let uiData = ui.uiData

        if sender.state == .began {
            guard let superView = ui.superview else {
                return
            }

            ui.superview!.bringSubviewToFront(ui)

            if superView != appScreen {
                let uiType = uiData.uiType
                let uiOnTable = generateEditorUI(uiData: uiData.copy())
                uiOnTable.transform = CGAffineTransform(scaleX: uiScale, y: uiScale)
                superView.addSubview(uiOnTable)

                uiOnTable.translatesAutoresizingMaskIntoConstraints = false
                uiOnTable.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
                uiOnTable.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true

                uiOnTable.isUserInteractionEnabled = true

                addGesture(ui: uiOnTable)

                ui.uiID = uiNum
                uiNum += 1
                UINumOfEachType[uiType]! += 1

                ui.translatesAutoresizingMaskIntoConstraints = true

                let center = ui.superview?.convert(ui.center, to: self.view)
                self.view.addSubview(ui)
                self.view.bringSubviewToFront(ui)
                ui.center = center ?? CGPoint()

                let uiName = uiTypeName[uiType]! + String(UINumOfEachType[uiType]!)
                ui.uiName = uiName

                uiDictionary[ui.uiID] = ui

                closeUITable(0)
            }

            selectedUIID = uiData.uiID
        }

        if sender.state == .ended {
            let center = ui.superview?.convert(ui.center, to: appScreen)
            appScreen.addSubview(ui)
            appScreen.bringSubviewToFront(ui)
            ui.center = center ?? CGPoint()

            self.saveApp()
        }

        let move = sender.translation(in: view)
        sender.view?.center.x += move.x
        sender.view?.center.y += move.y
        sender.setTranslation(CGPoint.zero, in: view)

        ui.uiData.x = ui.frame.origin.x
        ui.uiData.y = ui.frame.origin.y

    }

    func generateEditorUI(uiData: UIData) -> EditorUI {
        let ui: EditorUI!

        switch uiData.uiType {
        case .Label:
            ui = EditorUILabel(uiData: uiData)

        case .Button:
            ui = EditorUIButton(uiData: uiData)

        case .TextField:
            ui = EditorUITextField(uiData: uiData)

        case .Switch:
            ui = EditorUISwitch(uiData: uiData)

        case .Slider:
            ui = EditorUISlider(uiData: uiData)

        case .Table:
            ui = EditorUITable(uiData: uiData)
        }

        ui.delegate = self

        return ui
    }

    func editUI(ui: EditorUI) {
        let storyBoard = UIStoryboard(name: "UISettings", bundle: nil)
        guard let uiSettingsModal = storyBoard.instantiateInitialViewController() as? UISettingsModal else {
            fatalError()
        }

        uiSettingsModal.appID = self.appData.appID
        uiSettingsModal.ui = ui
        uiSettingsModal.uiData = ui.uiData
        uiSettingsModal.uiSettingsDelegate = self
        uiSettingsModal.codeEditorControllerDelegate = self

        navigationController?.present(uiSettingsModal, animated: true)
    }

    func getUIScript(ui: EditorUI) -> String {
        switch ui.uiData.uiType {
        case .Label:
            return ""

        case .Button:
            if let buttonData = ui.uiData.buttonData {
                var code = ""

                for type in ButtonUIData.CodeType.allCases {
                    code += """
                            func @\(ui.uiID)_\(type.rawValue) ()
                            {
                            \(buttonData.code[type]?.code ?? "")
                            }

                            """
                }

                return code

            } else {
                fatalError()
            }

        case .TextField:
            if let textFieldData = ui.uiData.textFieldData {
                var code = ""

                for type in TextFieldUIData.CodeType.allCases {
                    code += """
                            func @\(ui.uiID)_\(type.rawValue) ()
                            {
                            \(textFieldData.code[type]?.code ?? "")
                            }

                            """
                }

                return code

            } else {
                fatalError()
            }

        case .Switch:
            if let switchData = ui.uiData.switchData {
                var code = ""

                for type in SwitchUIData.CodeType.allCases {
                    code += """
                            func @\(ui.uiID)_\(type.rawValue) ()
                            {
                            \(switchData.code[type]?.code ?? "")
                            }

                            """
                }

                return code

            } else {
                fatalError()
            }

        case .Slider:
            if let sliderData = ui.uiData.sliderData {

                var code = ""

                for type in SliderUIData.CodeType.allCases {
                    code += """
                            func @\(ui.uiID)_\(type.rawValue) ()
                            {
                            \(sliderData.code[type]?.code ?? "")
                            }

                            """
                }

                return code

            } else {
                fatalError()
            }

        case .Table:
            return ""
        }
    }

    func getUINameDeclarationCode() -> String {
        var code = """

                   """

        for ui in uiDictionary {
            if ui.value.uiData.uiType == .Table {
                var listContent = ""
                var typeStr = ""
                if let tableData = ui.value.uiData.tableData {

                    if !(tableData.isCloud || tableData.isPersistent) {
                        for (index, content) in tableData.value.enumerated() {
                            listContent += "\"\(content)\""
                            if index < tableData.value.count - 1 {
                                listContent += ","
                            }
                        }
                    }

                    if tableData.isCloud {
                        typeStr += "#cloud "
                    }
                    if tableData.isPersistent {
                        typeStr += "#persistent"
                    }
                }


                code += """
                        list #ui \(typeStr) \(ui.value.uiName) = {\(listContent)}:\(ui.value.uiID)

                        """
            } else {
                code += """
                        var #ui \(ui.value.uiName) = \(ui.value.uiID)

                        """
            }
        }

        return code
    }

    func generateAppData() -> AppData {
        var uiDataTable = [UIData]()

        var funcID = 1

        var code = """
                   \(self.globalVariablesCode)

                   \(getUINameDeclarationCode())

                   func init()
                   {
                   \(initialCode)
                   }

                   """


        let sortedUIDictionary = uiDictionary.sorted(by: {
            $0.key < $1.key
        })

        for ui in sortedUIDictionary {
            let ui = ui.value

            let uiData = UIData(
                    uiID: ui.uiID,
                    uiName: ui.uiName,
                    uiType: ui.uiData.uiType,
                    x: ui.frame.origin.x / uiScale,
                    y: ui.frame.origin.y / uiScale,
                    width: ui.frame.width / uiScale,
                    height: ui.frame.height / uiScale
            )

            switch ui.uiData.uiType {
            case .Label:
                if let labelData = ui.uiData.labelData {
                    uiData.labelData = labelData
                } else {
                    fatalError()
                }

            case .Button:
                if var buttonData = ui.uiData.buttonData {
                    for type in ButtonUIData.CodeType.allCases {
                        buttonData.code[type]?.funcID = funcID
                        funcID += 1
                    }
                    uiData.buttonData = buttonData
                } else {
                    fatalError()
                }

            case .TextField:
                if var textFieldData = ui.uiData.textFieldData {
                    for type in TextFieldUIData.CodeType.allCases {
                        textFieldData.code[type]?.funcID = funcID
                        funcID += 1
                    }
                    uiData.textFieldData = textFieldData
                } else {
                    fatalError()
                }

            case .Switch:
                if var switchData = ui.uiData.switchData {
                    for type in SwitchUIData.CodeType.allCases {
                        switchData.code[type]?.funcID = funcID
                        funcID += 1
                    }
                    uiData.switchData = switchData
                } else {
                    fatalError()
                }

            case .Slider:
                if var sliderData = ui.uiData.sliderData {
                    for type in SliderUIData.CodeType.allCases {
                        sliderData.code[type]?.funcID = funcID
                        funcID += 1
                    }
                    uiData.sliderData = sliderData
                } else {
                    fatalError()
                }

            case .Table:
                if let tableData = ui.uiData.tableData {
                    uiData.tableData = tableData
                } else {
                    fatalError()
                }
            }

            uiDataTable.append(uiData)
            code += getUIScript(ui: ui)
        }

        let codeData = ConverterObjCpp().convertCode(code) ?? ""

        let appData = AppData(appName: appName, appID: self.appData.appID, uiData: uiDataTable, bytecode: codeData, globalVariableCode: self.globalVariablesCode)

        return appData
    }

    func getGlobalVariableCode() -> String {
        return """
               \(getUINameDeclarationCode())

               \(globalVariablesCode)

               """
    }

    func setGlobalVariableCode(code: String) {
        self.globalVariablesCode = code

        self.saveApp()
    }

    @IBAction func runButton(_: Any) {
        let storyboard = UIStoryboard(name: "AppRunner", bundle: nil)

        guard let appRunner = storyboard.instantiateInitialViewController() as? AppRunner else {
            fatalError()
        }

        appRunner.appData = generateAppData()

        navigationController?.pushViewController(appRunner, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func SettingsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AppSettings", bundle: nil)

        guard let appSettingsController = storyboard.instantiateInitialViewController() as? AppSettingsController else {
            fatalError()
        }

        appSettingsController.uiEditorController = self

        navigationController?.present(appSettingsController, animated: true)
    }

    func setAppName(appName: String?) {
        guard let appName: String = appName else {
            return
        }

        self.appName = appName

        self.navigationItem.title = appName
    }

    func saveApp() {
        let appData = generateAppData()

        AppDatabaseController.saveApp(appData: appData)
    }

    func addToHomeScreen() {
        AddShortcut.showShortcutScreen(appID: self.appData.appID, appName: self.appData.appName)
    }

    func copyShareLink() {
        AppDatabaseController.generateAppShortcutURL(appData: generateAppData())
    }

    func generateUITableModal() {
        let cornerRadius: CGFloat = 10

        self.uiTableModal = UIView()
        self.uiTableModal.backgroundColor = Color.uiCollectionBackground
        self.uiTableModal.layer.cornerRadius = cornerRadius
        self.uiTableModal.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 70)
        self.uiCollection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        self.uiCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.uiCollection.backgroundColor = .clear

        let titleBar = UIView()
        let titleLabel = UILabel()
        let doneButton = UIButton(type: .system)

        self.view.addSubview(self.uiTableModal)
        self.uiTableModal.addSubview(self.uiCollection)
        self.uiTableModal.addSubview(titleBar)
        titleBar.addSubview(titleLabel)
        titleBar.addSubview(doneButton)

        self.uiTableModal.translatesAutoresizingMaskIntoConstraints = false
        self.uiTableModalPosY = NSLayoutConstraint(item: self.uiTableModal!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        uiTableModalPosY.isActive = true
        NSLayoutConstraint.activate(
                [
                    self.uiTableModal.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                    self.uiTableModal.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                    self.uiTableModal.rightAnchor.constraint(equalTo: self.view.rightAnchor)
                ]
        )
        self.view.bringSubviewToFront(self.uiTableModal)

        titleBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    titleBar.topAnchor.constraint(equalTo: self.uiTableModal.topAnchor),
                    titleBar.leftAnchor.constraint(equalTo: self.uiTableModal.leftAnchor),
                    titleBar.rightAnchor.constraint(equalTo: self.uiTableModal.rightAnchor),
                    titleBar.heightAnchor.constraint(equalToConstant: 50)
                ]
        )

        titleBar.backgroundColor = .groupTableViewBackground
        titleBar.layer.cornerRadius = cornerRadius
        titleBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        titleLabel.text = "Add UI"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    titleLabel.centerXAnchor.constraint(equalTo: titleBar.centerXAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor)
                ]
        )

        doneButton.setTitle("Cancel", for: .normal)
        doneButton.titleLabel?.font = doneButton.titleLabel?.font.withSize(17)
        doneButton.addTarget(self, action: #selector(closeUITable(_:)), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    doneButton.leftAnchor.constraint(equalTo: titleBar.leftAnchor, constant: 15),
                    doneButton.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor)
                ]
        )

        self.uiCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    self.uiCollection.topAnchor.constraint(equalTo: titleBar.bottomAnchor, constant: 20),
                    self.uiCollection.bottomAnchor.constraint(equalTo: self.uiTableModal.bottomAnchor),
                    self.uiCollection.leftAnchor.constraint(equalTo: self.uiTableModal.leftAnchor, constant: 20),
                    self.uiCollection.rightAnchor.constraint(equalTo: self.uiTableModal.rightAnchor, constant: -20)
                ]
        )
    }

    @IBAction func openUITable(_ sender: Any) {
        self.view.layoutIfNeeded()

        self.uiTableModalPosY.constant = -250

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations:
        {
            self.view.layoutIfNeeded()
        })

    }

    @objc func closeUITable(_ sender: Any) {
        self.view.layoutIfNeeded()

        self.uiTableModalPosY.constant = 0

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func setListValue(uiID: Int, value: [String]) {
        self.uiDictionary[uiID]?.uiData.tableData?.value = value
        self.uiDictionary[uiID]?.reload()
    }

    func setListCloudType(uiID: Int, value: Bool) {
        self.uiDictionary[uiID]?.uiData.tableData?.isCloud = value
    }

    func setListPersistentType(uiID: Int, value: Bool) {
        self.uiDictionary[uiID]?.uiData.tableData?.isPersistent = value
    }
}
