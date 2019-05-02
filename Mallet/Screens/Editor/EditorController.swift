//
//  EditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class EditorController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var editorArea: UITextView!

    @IBOutlet weak var codeList: UITableView!

    var code: [String] = [String]()

    var currentCodeIndex = 0

    var uiData = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        currentCodeIndex = 0

        editorArea.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        editorArea.sizeToFit()
        editorArea.text = code[0]
        editorArea.autocapitalizationType = UITextAutocapitalizationType.none
        editorArea.spellCheckingType = UITextSpellCheckingType.no
        editorArea.delegate = self

        codeList.layer.cornerRadius = 15
        codeList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        //codeList.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return code.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        cell.textLabel?.text = "code" + String(indexPath.row)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCodeIndex = indexPath.row
        editorArea.text = code[currentCodeIndex]

        tableView.deselectRow(at: indexPath, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func RunButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RunApp", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? RunApp else {
            fatalError()
        }

        controller.code = code
        controller.uiDataStr = uiData

        navigationController?.pushViewController(controller, animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        code[currentCodeIndex] = editorArea.text
    }
}
