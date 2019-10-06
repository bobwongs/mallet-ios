//
//  BlockView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class Block: UIStackView {

    var delegate: blockDelegate?

    var index: Int

    var isOnTable: Bool

    var indent: Int

    var blockType: BlockType

    let isBracket: Bool

    private var indentConstraint = NSLayoutConstraint()

    private let blockView: BlockView

    private let indentSize: CGFloat = 25

    init(blockData: BlockData, index: Int, isOnTable: Bool, visualCodeEditorController: VisualCodeEditorController) {
        self.index = index
        self.isOnTable = isOnTable
        self.indent = blockData.indent
        self.blockType = blockData.blockType
        self.blockView = BlockView(blockData: blockData, visualCodeEditorController: visualCodeEditorController)

        if blockData.blockType == .Repeat ||
                   blockData.blockType == .While ||
                   blockData.blockType == .IF ||
                   blockData.blockType == .ELSE {
            self.isBracket = true
        } else {
            self.isBracket = false
        }

        super.init(frame: CGRect())

        self.translatesAutoresizingMaskIntoConstraints = false

        let blankView = UIView()
        blankView.translatesAutoresizingMaskIntoConstraints = false

        self.addArrangedSubview(blankView)

        let indentConstraint = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 50 * CGFloat(indent))
        self.indentConstraint = indentConstraint
        self.addConstraint(indentConstraint)

        self.addArrangedSubview(blockView)

        blockView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu(_:))))
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func changeBlockIndent(direction: Int) {

        if indent + direction < 0 {
            return
        }

        self.layoutIfNeeded()

        indent += direction

        indentConstraint.constant = self.indentSize * CGFloat(indent)

        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
        })
    }

    func args() -> [BlockView.Arg] {
        return blockView.args
    }

    @objc func showMenu(_ sender: UITapGestureRecognizer) {
        if isOnTable {
            return
        }

        becomeFirstResponder()

        let menu = UIMenuController.shared
        menu.isMenuVisible = true
        menu.arrowDirection = .down
        menu.setTargetRect(self.bounds, in: self)

        let deleteMenu = UIMenuItem(title: "Delete", action: #selector(self.onDelete(sender:)))
        let menuItems = [deleteMenu]
        menu.menuItems = menuItems
        menu.setMenuVisible(true, animated: true)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.onDelete(sender:)) {
            return true
        }

        return false
    }

    @objc func onDelete(sender: UIMenuItem) {
        self.delegate?.deleteBlock(index: self.index)
    }

    public func findArgViewStack(argContentView: ArgContent) -> UIStackView? {
        return self.blockView.findArgViewStack(argContentView: argContentView)
    }
}

class BlockView: UIView, UITextFieldDelegate {

    var args = [Arg]()

    private var argViews = [ArgView]()

    private let blockStackView = UIStackView(frame: CGRect())

    init(blockData: BlockData, visualCodeEditorController: VisualCodeEditorController) {

        super.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false

        self.layer.cornerRadius = 5
        /*
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        */
        if #available(iOS 13, *) {
            self.backgroundColor = .vplBlock
        } else {
            self.backgroundColor = .gray
        }

        blockStackView.axis = .horizontal
        blockStackView.distribution = .fill
        blockStackView.alignment = .center
        blockStackView.spacing = 5

        self.addSubview(blockStackView)

        let paddingV: CGFloat = 3
        let paddingH: CGFloat = 0

        blockStackView.translatesAutoresizingMaskIntoConstraints = false
        blockStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: paddingV).isActive = true
        blockStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -paddingV).isActive = true
        blockStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingH).isActive = true
        blockStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddingH).isActive = true


        //blockStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        var argSize = 0
        for content in blockData.contents {
            if argSize < content.order + 1 {
                argSize = content.order + 1
            }
        }

        args = [Arg](repeating: Arg(type: .Label(""), content: ""), count: argSize)

        for content in blockData.contents {

            switch content.value {
            case .Label(let text):
                let label = UILabel()
                label.text = text
                label.textAlignment = .center

                label.sizeToFit()

                blockStackView.addArrangedSubview(label)

            case .Arg(let argData):
                let argView = ArgView(contents: argData, visualCodeEditorController: visualCodeEditorController)
                blockStackView.addArrangedSubview(argView)

                self.argViews.append(argView)
            }
        }

        let leftView = UIView()
        leftView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockStackView.insertArrangedSubview(leftView, at: 0)

        let rightView = UIView()
        rightView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockStackView.addArrangedSubview(rightView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func setArg(textField: UITextField) {
        guard let inputField = textField as? InputField else {
            fatalError()
        }

        args[inputField.id].content = textField.text ?? ""
    }

    class InputField: UITextField {
        let id: Int

        init(id: Int) {
            self.id = id

            super.init(frame: CGRect())
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    struct Arg {
        let type: BlockContentType
        var content: String

        init(type: BlockContentType, content: String) {
            self.type = type
            self.content = content
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func findArgViewStack(argContentView: ArgContent) -> UIStackView? {
        let center = argContentView.superview!.convert(argContentView.center, to: self.blockStackView)

        for argView in self.argViews {
            if argView.frame.contains(center) {

                return argView.findArgViewStack(argContentView: argContentView)
            }
        }

        return nil
    }
}
