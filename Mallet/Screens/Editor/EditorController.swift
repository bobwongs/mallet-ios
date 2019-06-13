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

    var uiDataStr = ""

    var screenData: [UIData] = [UIData]()

    var uiName: Dictionary<String, Int> = Dictionary<String, Int>()

    var uiNames: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        code[0] = "//Declare global variables here\n\n" + code[0]
        code[1] = "//Called when the app starts\n\n" + code[1]
        //code[2] = "//Called when the button is pressed\n\n" + code[2]

        currentCodeIndex = 1

        editorArea.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        editorArea.sizeToFit()
        editorArea.text = code[currentCodeIndex]
        editorArea.autocapitalizationType = UITextAutocapitalizationType.none
        editorArea.spellCheckingType = UITextSpellCheckingType.no
        editorArea.delegate = self

        codeList.layer.cornerRadius = 15
        codeList.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        //codeList.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiNames.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        var cellTitle: String = ""

        switch indexPath.row {
        case 0:
            cellTitle = "Global Variable"
        case 1:
            cellTitle = "Initial Method"
        default:
            cellTitle = uiNames[indexPath.row - 2]
        }

        if code.count > indexPath.row + 1 {
            code.append("")
        }

        cell.textLabel?.text = cellTitle

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
        controller.uiDataStr = ScreenDataController().uiDataToString(uiData: screenData)

        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func EditUIButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UIEditor", bundle: nil)
        guard  let controller = storyboard.instantiateInitialViewController() as? UIEditorController else {
            fatalError()
        }

        controller.Editor = self

        for i in 0..<screenData.count {
            controller.UIDic[i] = screenData[i]
        }

        controller.UINum = screenData.count


        navigationController?.pushViewController(controller, animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        code[currentCodeIndex] = editorArea.text
    }

}
