//
//  TableUISettingsController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/12.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class TableUISettingsController: UISettingsController, TableContentEditorViewDelegate {

    private var tableDataSourceEditorView: TableContentEditorView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(appID: Int, ui: EditorUI, uiData: UIData, uiSettingsDelegate: UISettingsDelegate, codeEditorControllerDelegate: CodeEditorControllerDelegate) {
        super.init(appID: appID, ui: ui, uiData: uiData, uiSettingsDelegate: uiSettingsDelegate, codeEditorControllerDelegate: codeEditorControllerDelegate)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func numberOfOtherSections() -> Int {
        return 1
    }

    override func titleForHeader(section: Int) -> String {
        switch section {
        case 1:
            return "Table Contents"
        default:
            return ""
        }
    }

    override func numberOfRows(section: Int) -> Int {
        switch section {
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func cellForRow(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let addButton = UIButton(type: .system)
            if #available(iOS 13, *) {
                addButton.setImage(.add, for: .normal)
            } else {
                addButton.setTitle("", for: .normal)
            }
            addButton.addTarget(self, action: #selector(self.addTableElement(_:)), for: .touchUpInside)

            cell.addSubview(addButton)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                    [
                        addButton.topAnchor.constraint(equalTo: cell.topAnchor),
                        addButton.rightAnchor.constraint(equalTo: cell.rightAnchor),
                        addButton.widthAnchor.constraint(equalToConstant: 40),
                        addButton.heightAnchor.constraint(equalToConstant: 40)
                    ]
            )

            let tableView = TableContentEditorView(frame: CGRect(), tableDataSource: self.uiData.tableData?.value ?? [])
            tableView.tableContentEditorViewDelegate = self

            cell.addSubview(tableView)

            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                    [
                        tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor),
                        tableView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                        tableView.leftAnchor.constraint(equalTo: cell.leftAnchor),
                        tableView.rightAnchor.constraint(equalTo: cell.rightAnchor),
                        tableView.heightAnchor.constraint(equalToConstant: 200)
                    ]
            )

            self.tableDataSourceEditorView = tableView

            return cell

        default:
            return cell
        }
    }

    @objc func addTableElement(_ sender: UIButton) {
        self.tableDataSourceEditorView?.addTableElement()
    }

    func updateTable(dataSource: [String]) {
        self.uiData.tableData?.value = dataSource

        self.reload()
    }
}
