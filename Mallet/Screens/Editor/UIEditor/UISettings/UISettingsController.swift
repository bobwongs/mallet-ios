//
//  UISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class UISettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate {

    public var ui: EditorUI?

    public var uiData: UIData?

    public var delegate: UISettingsDelegate?

    @IBOutlet weak var settingsTableView: UITableView!

    @IBOutlet weak var settingsTableViewButtonConstraint: NSLayoutConstraint!

    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var navigationBarItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        navigationBar.delegate = self

        navigationBarItem.title = ui?.uiName
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }

        if let uiType = uiData?.uiType {
            switch uiType {
            case .Label:
                return "Label"

            case .Button:
                return "Button"

            case .TextField:
                return "Text Field"

            case .Switch:
                return "Switch"

            case .Slider:
                return "Slider"

            case .Table:
                return "Table"
            }
        }

        return ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }

        if let uiType = uiData?.uiType {
            switch uiType {
            case .Label:
                return 4

            case .Button:
                return 4

            case .TextField:
                return 4

            case .Switch:
                return 1

            case .Slider:
                return 3

            case .Table:
                return 1
            }
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        let titleLabel = UILabel()
        let textField = UITextField()

        textField.delegate = self

        textField.autocapitalizationType = .none

        let textFieldEvent: UIControl.Event = .editingDidEnd

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                titleLabel.text = "Name"
                textField.text = ui?.uiName
                textField.addTarget(self, action: #selector(self.setUIName(_:)), for: textFieldEvent)

            case 1:
                titleLabel.text = "Position X"
                textField.text = "\(uiData?.x ?? 0)"
                textField.addTarget(self, action: #selector(self.setUIPosX(_:)), for: textFieldEvent)

            case 2:
                titleLabel.text = "Position Y"
                textField.text = "\(uiData?.y ?? 0)"
                textField.addTarget(self, action: #selector(self.setUIPosY(_:)), for: textFieldEvent)

            case 3:
                titleLabel.text = "Width"
                textField.text = "\(uiData?.width ?? 0)"
                textField.addTarget(self, action: #selector(self.setUIWidth(_:)), for: textFieldEvent)

            case 4:
                titleLabel.text = "Height"
                textField.text = "\(uiData?.height ?? 0)"
                textField.addTarget(self, action: #selector(self.setUIHeight(_:)), for: textFieldEvent)

            default:
                break
            }


        } else {
            switch uiData?.uiType {
            case .Label:
                switch indexPath.row {
                case 0:
                    titleLabel.text = "Text"
                    textField.text = uiData?.labelData?.text ?? ""
                    textField.addTarget(self, action: #selector(self.setLabelText(_:)), for: textFieldEvent)

                case 1:
                    titleLabel.text = "Font Size"
                    textField.text = "\(uiData?.labelData?.fontSize ?? 0)"
                    textField.addTarget(self, action: #selector(self.setLabelFontSize(_:)), for: textFieldEvent)

                case 2:
                    titleLabel.text = "Font Color"
                    textField.text = uiData?.labelData?.fontColor
                    textField.addTarget(self, action: #selector(self.setLabelFontColor(_:)), for: textFieldEvent)

                case 3:
                    titleLabel.text = "Alignment"
                    let text: String!
                    switch (uiData?.labelData?.alignment ?? TextUIAlignment.left) {
                    case .center:
                        text = "center"
                    case .left:
                        text = "left"
                    case .right:
                        text = "right"
                    }
                    textField.text = text
                    textField.addTarget(self, action: #selector(self.setLabelTextAlignment(_:)), for: textFieldEvent)

                default:
                    break
                }

            case .Button:
                switch indexPath.row {
                case 0:
                    titleLabel.text = "Text"
                    textField.text = uiData?.buttonData?.text ?? ""
                    textField.addTarget(self, action: #selector(self.setButtonText(_:)), for: textFieldEvent)

                case 1:
                    titleLabel.text = "Font Size"
                    textField.text = "\(uiData?.buttonData?.fontSize ?? 0)"
                    textField.addTarget(self, action: #selector(self.setButtonFontSize(_:)), for: textFieldEvent)

                case 2:
                    titleLabel.text = "Font Color"
                    textField.text = uiData?.buttonData?.fontColor
                    textField.addTarget(self, action: #selector(self.setButtonFontColor(_:)), for: textFieldEvent)

                case 3:
                    titleLabel.text = "Background Color"
                    textField.text = uiData?.buttonData?.backgroundColor
                    textField.addTarget(self, action: #selector(self.setButtonBackgroundColor(_:)), for: textFieldEvent)

                default:
                    break
                }

            case .TextField:
                break

            case .Switch:
                break

            case .Slider:
                break

            default:
                break
            }
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.frame.size = cell.frame.size
        cell.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    private func reload() {
        if let uiData = self.uiData {
            self.ui?.reload(uiData: uiData)

            self.delegate?.saveApp()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }

    //######################
    // Default

    @objc private func setUIName(_ textField: UITextField) {
        self.ui?.uiName = textField.text ?? ""
        self.reload()
    }

    @objc private func setUIPosX(_ textField: UITextField) {
        self.uiData?.x = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    @objc private func setUIPosY(_ textField: UITextField) {
        self.uiData?.y = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    @objc private func setUIWidth(_ textField: UITextField) {
        self.uiData?.width = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    @objc private func setUIHeight(_ textField: UITextField) {
        self.uiData?.height = CGFloat(Float(textField.text ?? "") ?? 0)
        self.reload()
    }

    //######################

    //######################
    //Label
    @objc private func setLabelText(_ textField: UITextField) {
        self.uiData?.labelData?.text = textField.text ?? ""
        self.reload()
    }

    @objc private func setLabelFontSize(_ textField: UITextField) {
        self.uiData?.labelData?.fontSize = Int(textField.text ?? "") ?? 0
        self.reload()
    }

    @objc private func setLabelFontColor(_ textField: UITextField) {
        self.uiData?.labelData?.fontColor = textField.text ?? ""
        self.reload()
    }

    @objc private func setLabelTextAlignment(_ textField: UITextField) {
        let alignment: TextUIAlignment!
        switch textField.text {
        case "center":
            alignment = .center
        case "left":
            alignment = .left
        case "right":
            alignment = .right
        default:
            alignment = .left
        }
        self.uiData?.labelData?.alignment = alignment
        self.reload()
    }

    //######################

    //######################
    //Button
    @objc private func setButtonText(_ textField: UITextField) {
        self.uiData?.buttonData?.text = textField.text ?? ""
        self.reload()
    }

    @objc private func setButtonFontSize(_ textField: UITextField) {
        self.uiData?.buttonData?.fontSize = Int(textField.text ?? "") ?? 0
        self.reload()
    }

    @objc private func setButtonFontColor(_ textField: UITextField) {
        self.uiData?.buttonData?.fontColor = textField.text ?? ""
        self.reload()
    }

    @objc private func setButtonBackgroundColor(_ textField: UITextField) {
        self.uiData?.buttonData?.backgroundColor = textField.text ?? ""
        self.reload()
    }

    //######################

    //######################
    //TextField

    //######################

    //######################
    //Switch

    //######################

    //######################
    //Slider

    //######################
}

public protocol UISettingsDelegate {
    func saveApp()
}