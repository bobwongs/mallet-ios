//
//  BlockView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class Block: UIStackView {

    public var index: Int

    public var isOnTable: Bool

    var indent: Int

    var blockType: BlockType

    var indentConstraint = NSLayoutConstraint()

    let blockView: BlockView

    init(blockData: BlockData, index: Int, isOnTable: Bool) {
        self.index = index
        self.isOnTable = isOnTable
        self.indent = blockData.indent
        self.blockType = blockData.blockType
        self.blockView = BlockView(blockData: blockData)

        super.init(frame: CGRect())


        self.translatesAutoresizingMaskIntoConstraints = false

        let blankView = UIView()
        blankView.translatesAutoresizingMaskIntoConstraints = false

        self.addArrangedSubview(blankView)

        let indentConstraint = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 50 * CGFloat(indent))
        self.indentConstraint = indentConstraint
        self.addConstraint(indentConstraint)

        self.addArrangedSubview(blockView)

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

        indentConstraint.constant = 50 * CGFloat(indent)

        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
        })
    }

    func args() -> [BlockView.Arg] {
        return blockView.args
    }

}

class BlockView: UIView {

    var args = [Arg]()

    init(blockData: BlockData) {

        super.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false

        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.backgroundColor = UIColor.gray

        let blockStackView = UIStackView(frame: CGRect())
        blockStackView.axis = .horizontal
        blockStackView.distribution = .fill
        blockStackView.spacing = 5

        self.addSubview(blockStackView)

        let paddingV: CGFloat = 7
        let paddingH: CGFloat = 7

        blockStackView.translatesAutoresizingMaskIntoConstraints = false
        blockStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: paddingV).isActive = true
        blockStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -paddingV).isActive = true
        blockStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingH).isActive = true
        blockStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddingH).isActive = true

        blockStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        var width: CGFloat = 0

        var argSize = 0
        for content in blockData.contents {
            if argSize < content.order + 1 {
                argSize = content.order + 1
            }
        }

        args = [Arg](repeating: Arg(type: .InputAll, content: ""), count: argSize)

        for content in blockData.contents {

            switch content.type {
            case .Label:
                let text = UILabel()
                text.text = content.value
                text.textColor = UIColor.white
                text.textAlignment = .center

                text.sizeToFit()

                width += text.frame.width + 10

                blockStackView.addArrangedSubview(text)

            case .InputAll:
                let textField = InputField(id: content.order)

                args[content.order] = Arg(type: content.type, content: content.value)

                textField.addTarget(self, action: #selector(setArg), for: .editingChanged)

                textField.text = content.value
                textField.textColor = UIColor.black
                textField.backgroundColor = UIColor.white
                textField.textAlignment = .center
                textField.layer.cornerRadius = 5

                textField.sizeToFit()

                width += textField.frame.width + 10

                blockStackView.addArrangedSubview(textField)

            case .InputSingleVariable:
                //TODO:

                let textField = InputField(id: content.order)

                args[content.order] = Arg(type: content.type, content: content.value)

                textField.addTarget(self, action: #selector(setArg), for: .editingChanged)

                textField.text = content.value
                textField.textColor = UIColor.black
                textField.backgroundColor = UIColor.white
                textField.textAlignment = .center
                textField.layer.cornerRadius = 5

                textField.sizeToFit()

                width += textField.frame.width + 10

                blockStackView.addArrangedSubview(textField)


            }


        }
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

}
