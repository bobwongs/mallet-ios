//
//  CodeEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class CodeEditorController: UIViewController, UINavigationControllerDelegate {

    enum EditorMode {
        case Text
        case Visual
    }

    @IBOutlet weak var TextCodeEditorView: UIView!
    @IBOutlet weak var VisualCodeEditorView: UIView!

    var textCodeEditorController: TextCodeEditorController!
    var visualCodeEditorController: VisualCodeEditorController!

    var codeEditorControllerDelegate: CodeEditorControllerDelegate?

    var appID: Int?

    let initialEditorMode = EditorMode.Visual

    var editorMode: EditorMode!

    var codeTitle = ""

    var codeStr = ""

    var updateCodeClosure: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        initEditorView()
        initEditor()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.updateCode()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let textCodeEditorController = segue.destination as? TextCodeEditorController {
            self.textCodeEditorController = textCodeEditorController
        }

        if let visualCodeEditorController = segue.destination as? VisualCodeEditorController {
            self.visualCodeEditorController = visualCodeEditorController
        }
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is UISettingsController {
            self.updateCode()

            (viewController as! UISettingsController).uiSettingsDelegate.saveApp()
        }
    }

    func updateCode() {
        if editorMode == .Visual {
            codeStr = visualCodeEditorController.vplToCode()
        }

        self.updateCodeClosure?(self.codeStr)
    }

    func initEditorView() {
        self.navigationItem.title = self.codeTitle

        navigationController?.delegate = self
    }

    func initEditor() {
        editorMode = initialEditorMode

        switchEditorModeTo(mode: editorMode)
    }

    func switchEditorMode() {
        if editorMode == .Text {
            switchEditorModeTo(mode: .Visual)
        } else {
            codeStr = visualCodeEditorController.vplToCode()
            switchEditorModeTo(mode: .Text)
        }
    }

    func switchEditorModeTo(mode: EditorMode) {
        self.view.endEditing(true)

        if mode == .Visual {
            editorMode = .Visual

            hideTextCodeEditorView()
            showVisualCodeEditorView()

        } else if mode == .Text {
            editorMode = .Text

            hideVisualCodeEditorView()
            showTextCodeEditorView()

            textCodeEditorController.editorArea.text = codeStr
        }
    }

    func showTextCodeEditorView() {
        TextCodeEditorView.isHidden = false

        TextCodeEditorView.translatesAutoresizingMaskIntoConstraints = false
        TextCodeEditorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        TextCodeEditorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        TextCodeEditorView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        TextCodeEditorView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }

    func hideTextCodeEditorView() {
        TextCodeEditorView.isHidden = true
    }

    func showVisualCodeEditorView() {
        VisualCodeEditorView.isHidden = false

        VisualCodeEditorView.translatesAutoresizingMaskIntoConstraints = false
        VisualCodeEditorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        VisualCodeEditorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        VisualCodeEditorView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        VisualCodeEditorView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }

    func hideVisualCodeEditorView() {
        VisualCodeEditorView.isHidden = true
    }

    @IBAction func switchModeButton(_ sender: Any) {
        switchEditorMode()
    }

    @IBAction func variableSettingsButton(_ sender: Any) {
        if let codeEditorControllerDelegate = self.codeEditorControllerDelegate {

            let storyboard = UIStoryboard(name: "VariableSettings", bundle: nil)
            guard let variableSettingsController = storyboard.instantiateInitialViewController() as? VariableSettingsController else {
                fatalError()
            }
            self.updateCode()

            variableSettingsController.codeStr = codeEditorControllerDelegate.getAllCodeStr()

            variableSettingsController.appID = self.appID

            navigationController?.present(variableSettingsController, animated: true)
        }
    }
}

protocol CodeEditorControllerDelegate {
    func getAllCodeStr() -> String
}