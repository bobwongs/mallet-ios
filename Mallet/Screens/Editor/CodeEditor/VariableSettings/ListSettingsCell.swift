//
//  ListSettingsCell.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/14.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ListSettingsCell: UITableViewCell, UITextFieldDelegate {

    let listTypeButton = UIButton(type: .system)

    private let index: Int

    private let delegate: ListSettingsCellDelegate

    private var listValue: [String]

    init(reuseIdentifier: String?, index: Int, listData: VariableSettingsController.ListData, delegate: ListSettingsCellDelegate) {

        self.delegate = delegate

        self.index = index

        self.listValue = listData.value

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.frame = self.frame
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        let topChildStackView = UIStackView()
        topChildStackView.axis = .horizontal
        topChildStackView.alignment = .fill
        topChildStackView.spacing = 10
        stackView.addArrangedSubview(topChildStackView)

        let bottomChildStackView = UIStackView()
        bottomChildStackView.axis = .horizontal
        bottomChildStackView.alignment = .fill
        bottomChildStackView.spacing = 10
        stackView.addArrangedSubview(bottomChildStackView)

        topChildStackView.translatesAutoresizingMaskIntoConstraints = false
        topChildStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        updateListType(type: listData.type)
        listTypeButton.addTarget(self, action: #selector(self.updateListType(_:)), for: .touchDown)
        topChildStackView.addArrangedSubview(listTypeButton)
        listTypeButton.translatesAutoresizingMaskIntoConstraints = false
        listTypeButton.widthAnchor.constraint(equalTo: topChildStackView.heightAnchor).isActive = true
        listTypeButton.heightAnchor.constraint(equalTo: topChildStackView.heightAnchor).isActive = true

        let listNameTextField = UITextField()
        listNameTextField.placeholder = "Name"
        listNameTextField.text = listData.name
        topChildStackView.addArrangedSubview(listNameTextField)
        listNameTextField.translatesAutoresizingMaskIntoConstraints = false
        listNameTextField.addTarget(self, action: #selector(self.updateListName(_:)), for: .editingDidEnd)

        let spaceView = UIView()
        bottomChildStackView.addArrangedSubview(spaceView)
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.widthAnchor.constraint(equalTo: topChildStackView.heightAnchor).isActive = true

        let listContentEditor = TableContentEditorView(frame: CGRect(), tableDataSource: listValue)
        bottomChildStackView.addArrangedSubview(listContentEditor)
        listContentEditor.translatesAutoresizingMaskIntoConstraints = false
        listContentEditor.heightAnchor.constraint(equalToConstant: 200).isActive = true

        listNameTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

    @objc func updateListType(_ sender: UIButton) {
        self.delegate.updateListType(index: self.index, cell: self)
    }

    @objc func updateListName(_ sender: UITextField) {
        self.delegate.updateListName(index: self.index, name: sender.text ?? "")
    }

    //TODO: updateListValue

    func updateListType(type: VariableSettingsController.VariableType) {
        switch type {
        case .normal:
            listTypeButton.setTitle("N", for: .normal)
        case .persistent:
            listTypeButton.setTitle("D", for: .normal)
        case .cloud:
            listTypeButton.setTitle("C", for: .normal)
        }
    }
}

protocol ListSettingsCellDelegate {
    func updateListType(index: Int, cell: ListSettingsCell)

    func updateListName(index: Int, name: String)

    func updateListValue(index: Int, value: [String])
}