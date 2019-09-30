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

    @IBOutlet weak var settingsTableView: UITableView!

    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        navigationBar.delegate = self
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

        return "Label"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        if indexPath.section == 0 {
            let titleLabel = UILabel()
            let textField = UITextField()

            let textFieldEvent: UIControl.Event = .editingDidEnd

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

            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.frame.size = cell.frame.size
            cell.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
            /*
            NSLayoutConstraint.activate(
                    [
                        stackView.topAnchor.constraint(equalTo: cell.topAnchor),
                        stackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                        stackView.leftAnchor.constraint(equalTo: cell.leftAnchor),
                        stackView.rightAnchor.constraint(equalTo: cell.rightAnchor)
                    ]
            )
            */

            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(textField)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true

        } else {

        }

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
        }
    }

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
}
