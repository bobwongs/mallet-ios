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

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    func textViewDidChange(_ textView: UITextView) {
        if let codeEditorController = self.parent as? CodeEditorController {
            codeEditorController.codeStr = editorArea.text
        }
    }
}
