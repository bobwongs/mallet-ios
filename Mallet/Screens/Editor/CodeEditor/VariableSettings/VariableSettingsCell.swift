//
//  VariableSettingsCellTableViewCell.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/29.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VariableSettingsCell: UITableViewCell, UITextFieldDelegate {

    var delegate: VariableSettingsCellDelegate?

    let variableTypeButton = UIButton(type: .system)

    let index: Int!

    init(reuseIdentifier: String?, index: Int, variableData: VariableSettingsController.VariableData) {
        self.index = index

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.frame = self.frame
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true

        variableTypeButton.setTitle("N", for: .normal)
        variableTypeButton.addTarget(self, action: #selector(self.updateVariableType(_:)), for: .touchDown)
        stackView.addArrangedSubview(variableTypeButton)
        variableTypeButton.translatesAutoresizingMaskIntoConstraints = false
        variableTypeButton.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        variableTypeButton.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true

        let variableNameTextField = UITextField()
        variableNameTextField.placeholder = "Name"
        variableNameTextField.text = variableData.name
        stackView.addArrangedSubview(variableNameTextField)
        variableNameTextField.translatesAutoresizingMaskIntoConstraints = false
        variableNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.35).isActive = true
        variableNameTextField.addTarget(self, action: #selector(self.updateVariableName(_:)), for: .editingDidEnd)

        let variableValueTextField = UITextField()
        variableValueTextField.placeholder = "Value"
        variableValueTextField.text = variableData.value
        stackView.addArrangedSubview(variableValueTextField)
        variableValueTextField.translatesAutoresizingMaskIntoConstraints = false
        variableValueTextField.addTarget(self, action: #selector(self.updateVariableValue(_:)), for: .editingDidEnd)

        variableNameTextField.delegate = self
        variableValueTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }

    @objc func updateVariableType(_ sender: UIButton) {
        delegate?.updateVariableType(index: self.index, cell: self)
    }

    @objc func updateVariableName(_ sender: UITextField) {
        delegate?.updateVariableName(index: self.index, name: sender.text ?? "")
    }

    @objc func updateVariableValue(_ sender: UITextField) {
        delegate?.updateVariableValue(index: self.index, value: sender.text ?? "")
    }

    public func updateVariableType(type: VariableSettingsController.VariableType) {
        switch type {
        case .normal:
            variableTypeButton.setTitle("N", for: .normal)
        case .persistent:
            variableTypeButton.setTitle("D", for: .normal)
        case .cloud:
            variableTypeButton.setTitle("C", for: .normal)
        }
    }
}


protocol VariableSettingsCellDelegate {
    func updateVariableType(index: Int, cell: VariableSettingsCell)

    func updateVariableName(index: Int, name: String)

    func updateVariableValue(index: Int, value: String)
}