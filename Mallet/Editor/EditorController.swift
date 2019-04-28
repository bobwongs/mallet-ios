//
//  EditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class EditorController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var editorArea: UITextView!

    var code: [String] = [String]()

    var editorText = " var str:String str=\"ho ge\" print(str)"

    var uiData = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        editorText = code[0]

        editorArea.layer.borderWidth = 1
        editorArea.layer.borderColor = UIColor.gray.cgColor
        editorArea.text = editorText
        editorArea.autocapitalizationType = UITextAutocapitalizationType.none
        editorArea.spellCheckingType = UITextSpellCheckingType.no
        editorArea.delegate = self
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
        code[0] = editorArea.text
        print(editorText)
    }
}
