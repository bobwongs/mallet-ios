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

    var appID: Int!

    var ui: UIView!

    var uiData: UIData!

    var uiEditorController: UIEditorController?

    let initialEditorMode = EditorMode.Visual

    var editorMode: EditorMode!

    var codeStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        initEditorView()
        initEditor()
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
        if editorMode == .Visual {
            codeStr = visualCodeEditorController.vplToCode()
        }

        if viewController is UIEditorController {
            updateCode()

            (viewController as! UIEditorController).saveApp()
        }
    }

    func updateCode() {
        switch uiData.uiType {
        case .Button:
            uiData.buttonData?.onTap.code = codeStr

        case .TextField:
            uiData.textFieldData?.onChange.code = codeStr

        case .Switch:
            uiData.switchData?.onChange.code = codeStr

        case .Slider:
            uiData.sliderData?.onChange.code = codeStr

        default:
            break
        }
    }

    func initEditorView() {
        self.navigationItem.title = uiData.uiName

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

            if editorMode != initialEditorMode {
                codeStr = visualCodeEditorController.vplToCode()
            }

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
        let storyboard = UIStoryboard(name: "VariableSettings", bundle: nil)
        guard let variableSettingsController = storyboard.instantiateInitialViewController() as? VariableSettingsController else {
            fatalError()
        }

        updateCode()

        variableSettingsController.codeStr = self.uiEditorController?.getCodeStr()

        variableSettingsController.appID = self.appID

        navigationController?.present(variableSettingsController, animated: true)
    }
}
