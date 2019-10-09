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

    let isBracket: Bool

    public let initialBlockData: BlockData

    private var indentConstraint = NSLayoutConstraint()

    private let blockView: BlockView

    private let indentSize: CGFloat = 25

    init(blockData: BlockData, index: Int, isOnTable: Bool, visualCodeEditorController: VisualCodeEditorController) {
        self.index = index
        self.isOnTable = isOnTable
        self.indent = blockData.indent
        self.blockView = BlockView(blockData: blockData, visualCodeEditorController: visualCodeEditorController)
        self.initialBlockData = blockData

        self.isBracket = blockData.funcType == .Bracket

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

    public func getCodeStr() -> String {
        return self.blockView.getCodeStr(newLine: true)
    }
}

class BlockView: UIView, UITextFieldDelegate {

    private var argViews = [ArgView?]()

    private let blockStackView = UIStackView(frame: CGRect())

    private let funcName: String

    private let funcType: BlockType

    init(blockData: BlockData, visualCodeEditorController: VisualCodeEditorController) {

        self.funcName = blockData.funcName

        self.funcType = blockData.funcType

        super.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false

        self.layer.cornerRadius = 5

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
        let paddingH: CGFloat = 3

        blockStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    blockStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: paddingV),
                    blockStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -paddingV),
                    blockStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingH),
                    blockStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddingH),
                    blockStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
                ]
        )

        var argCount = 0
        for content in blockData.contents {
            if argCount < content.order + 1 {
                argCount = content.order + 1
            }
        }

        argViews = [ArgView?](repeating: nil, count: argCount)

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

                self.argViews[content.order] = argView
            }
        }

        /*
        let leftView = UIView()
        leftView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockStackView.insertArrangedSubview(leftView, at: 0)

        let rightView = UIView()
        rightView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockStackView.addArrangedSubview(rightView)
        */
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func findArgViewStack(argContentView: ArgContent) -> UIStackView? {
        let center = argContentView.superview!.convert(argContentView.center, to: self.blockStackView)

        for argView in self.argViews {
            if let argView = argView {
                if argView.frame.contains(center) {

                    return argView.findArgViewStack(argContentView: argContentView)
                }
            }
        }

        return nil
    }

    public func getCodeStr() -> String {
        getCodeStr(newLine: false)
    }

    public func getCodeStr(newLine: Bool) -> String {
        if self.funcName == "else" {
            return self.funcName
        }

        var codeStr = ""

        switch self.funcType {
        case .Bracket:
            fallthrough

        case .Block:
            codeStr = "\(self.funcName)("

            for argIndex in 0..<self.argViews.count {
                codeStr += self.argViews[argIndex]?.getCodeStr() ?? ""
                if argIndex + 1 < self.argViews.count {
                    codeStr += ","
                }
            }

            codeStr += ")"

        case .Assign:
            if self.argViews.count != 2 {
                return ""
            }

            codeStr = "\(argViews[0]?.getCodeStr() ?? "") = \(argViews[1]?.getCodeStr() ?? "")"

        case .Declare:
            if self.argViews.count != 2 {
                return ""
            }

            codeStr = "var \(argViews[0]?.getCodeStr() ?? "") = \(argViews[1]?.getCodeStr() ?? "")"

        default:
            //TODO:
            break
        }

        if newLine {
            codeStr += "\n"
        }

        return codeStr
    }
}
