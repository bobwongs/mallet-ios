//
//  TableContentEditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/11.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class TableContentEditorView: UITableView, UITableViewDelegate, UITableViewDataSource, TableViewContentEditorViewCellDelegate {

    var tableContentEditorViewDelegate: TableContentEditorViewDelegate?

    var tableDataSource = [String]()

    init(frame: CGRect, tableDataSource: [String]) {
        super.init(frame: frame, style: .plain)

        self.tableDataSource = tableDataSource

        self.delegate = self
        self.dataSource = self

        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableContentEditorViewCell(reuseIdentifier: "Cell", index: indexPath.row, value: self.tableDataSource[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            self.updateTableData()
        }
    }

    func addTableElement() {
        self.tableDataSource.append("")
        self.updateTableData(index: self.tableDataSource.count - 1, value: "")

        DispatchQueue.main.async {
            self.scrollToRow(at: IndexPath(row: self.tableDataSource.count - 1, section: 0), at: .top, animated: true)
        }
    }

    func updateTableData() {
        self.tableContentEditorViewDelegate?.updateTable(dataSource: self.tableDataSource)

        self.reloadData()

        if self.tableDataSource.count > 0 {
            DispatchQueue.main.async {
                self.scrollToRow(at: IndexPath(row: self.tableDataSource.count - 1, section: 0), at: .top, animated: false)
            }
        }
    }

    fileprivate func updateTableData(index: Int, value: String) {
        self.tableDataSource[index] = value

        self.tableContentEditorViewDelegate?.updateTable(dataSource: self.tableDataSource)

        self.reloadData()
    }
}

fileprivate class TableContentEditorViewCell: UITableViewCell, UITextFieldDelegate {

    var delegate: TableViewContentEditorViewCellDelegate?

    private let index: Int

    init(reuseIdentifier: String?, index: Int, value: String) {
        self.index = index

        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
                    stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                    stackView.heightAnchor.constraint(equalToConstant: 40)
                ]
        )

        stackView.axis = .horizontal

        let indexLabel = UILabel()
        indexLabel.text = String(index + 1)

        let textField = UITextField()
        textField.placeholder = "value"
        textField.text = value
        textField.delegate = self
        textField.textAlignment = .center

        stackView.addArrangedSubview(indexLabel)
        stackView.addArrangedSubview(textField)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.updateTableData(index: self.index, value: textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}

fileprivate protocol TableViewContentEditorViewCellDelegate {
    func updateTableData(index: Int, value: String)
}

protocol TableContentEditorViewDelegate {
    func updateTable(dataSource: [String])
}
