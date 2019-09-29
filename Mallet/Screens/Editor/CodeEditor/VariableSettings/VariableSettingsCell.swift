//
//  VariableSettingsCellTableViewCell.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VariableSettingsCell: UITableViewCell, UITextFieldDelegate {

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.frame = self.frame
        self.addSubview(stackView)

        let variableNameTextField = UITextField()
        variableNameTextField.placeholder = "Name"
        stackView.addArrangedSubview(variableNameTextField)
        variableNameTextField.translatesAutoresizingMaskIntoConstraints = false
        variableNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true

        let variableValueTextField = UITextField()
        variableValueTextField.placeholder = "Value"
        stackView.addArrangedSubview(variableValueTextField)
        variableValueTextField.translatesAutoresizingMaskIntoConstraints = false
        variableValueTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true

        variableNameTextField.delegate = self
        variableValueTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }
}
