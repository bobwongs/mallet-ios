//
//  ListSettingsCell.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/14.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ListSettingsCell: UITableViewCell, UITextFieldDelegate, TableContentEditorViewDelegate {


    let listTypeButton = UIButton(type: .system)

    private let index: Int

    private let delegate: ListSettingsCellDelegate

    private var listValue: [String]

    private let listEditor: TableContentEditorView!

    init(reuseIdentifier: String?, index: Int, listData: VariableSettingsController.ListData, delegate: ListSettingsCellDelegate) {

        self.delegate = delegate

        self.index = index

        self.listValue = listData.value

        self.listEditor = TableContentEditorView(frame: CGRect(), tableDataSource: self.listValue)

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.frame = self.frame
        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
                [
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
                ]
        )

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
        bottomChildStackView.translatesAutoresizingMaskIntoConstraints = false

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

        let addElementButton = UIButton(type: .system)
        if #available(iOS 13, *) {
            addElementButton.setImage(.add, for: .normal)
        } else {
            addElementButton.setTitle("Add", for: .normal)
        }
        addElementButton.addTarget(self, action: #selector(self.addListElement(_:)), for: .touchUpInside)
        topChildStackView.addArrangedSubview(addElementButton)
        addElementButton.translatesAutoresizingMaskIntoConstraints = false
        addElementButton.widthAnchor.constraint(equalTo: topChildStackView.heightAnchor).isActive = true
        addElementButton.heightAnchor.constraint(equalTo: topChildStackView.heightAnchor).isActive = true

        let spaceView = UIView()
        bottomChildStackView.addArrangedSubview(spaceView)
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        spaceView.widthAnchor.constraint(equalTo: topChildStackView.heightAnchor).isActive = true

        bottomChildStackView.addArrangedSubview(listEditor)
        listEditor.tableContentEditorViewDelegate = self
        listEditor.translatesAutoresizingMaskIntoConstraints = false
        listEditor.heightAnchor.constraint(equalToConstant: 200).isActive = true

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

    @objc func addListElement(_ sender: UIButton) {
        self.listEditor.addTableElement()
    }

    func updateTable(dataSource: [String]) {
        self.listValue = dataSource

        self.delegate.updateListValue(index: self.index, value: self.listValue)
    }
}

protocol ListSettingsCellDelegate {
    func updateListType(index: Int, cell: ListSettingsCell)

    func updateListName(index: Int, name: String)

    func updateListValue(index: Int, value: [String])
}