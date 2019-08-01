//
//  EditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class TextCodeEditorController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var editorArea: UITextView!

    //@IBOutlet weak var codeList: UITableView!

    var code: [String] = [String]()

    var currentCodeIndex = 0

    var uiData = ""

    var uiDataStr = ""

    var screenData: [UIData] = [UIData]()

    var uiNameDic: Dictionary<String, Int> = Dictionary<String, Int>()

    var uiNames: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func RunButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RunApp", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? AppRunner else {
            fatalError()
        }

        controller.code = code
        controller.uiDataStr = ScreenDataController().uiDataToString(uiData: screenData)
        controller.uiName = uiNameDic

        navigationController?.pushViewController(controller, animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        code[currentCodeIndex] = editorArea.text
    }


}
