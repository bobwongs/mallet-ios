//
//  SettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/20.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppSettingsController: UITableViewController, UITextFieldDelegate {
    enum sectionType: Int, CaseIterable {
        case setAppName = 0
        case addIconToHome = 1
        case getShareLink = 2
    }

    let editorDelegate: EditorDelegate

    init(editorDelegate: EditorDelegate) {
        self.editorDelegate = editorDelegate

        super.init(style: .grouped)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        switch indexPath.section {
        case sectionType.setAppName.rawValue:
            let titleLabel = UILabel()
            let textField = UITextField()

            titleLabel.text = "App Name"
            textField.text = self.editorDelegate.getAppName()
            textField.addTarget(self, action: #selector(self.setAppName(_:)), for: .editingDidEnd)
            textField.delegate = self

            let stackView = UIStackView()
            stackView.axis = .horizontal
            cell.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                    [
                        stackView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.95),
                        stackView.heightAnchor.constraint(equalToConstant: cell.frame.height),
                        stackView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                        stackView.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
                    ]
            )

            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(textField)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4).isActive = true

            break

        case sectionType.addIconToHome.rawValue:
            cell.textLabel?.text = "Add icon to home screen"
            cell.textLabel?.textAlignment = .center
            if #available(iOS 13, *) {
                cell.textLabel?.textColor = .systemBlue
            } else {
                cell.textLabel?.textColor = .blue
            }

        case sectionType.getShareLink.rawValue:
            cell.textLabel?.text = "Share app"
            cell.textLabel?.textAlignment = .center
            if #available(iOS 13, *) {
                cell.textLabel?.textColor = .systemBlue
            } else {
                cell.textLabel?.textColor = .blue
            }

        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case sectionType.addIconToHome.rawValue:
            self.editorDelegate.addToHomeScreen()

        case sectionType.getShareLink.rawValue:
            self.share(text: editorDelegate.generateShareLink())

        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @objc func setAppName(_ textField: UITextField) {
        self.editorDelegate.setAppName(appName: textField.text)
    }

    func share(text: String) {
        let activityItems = [text]

        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        self.present(activityViewController, animated: true)
    }
}
