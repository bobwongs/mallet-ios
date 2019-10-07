//
//  ArgView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/04.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ArgView: UIView {

    private let contents: [ArgContentType]!

    static let spaceBetweenContents: CGFloat = 5.0

    private let contentsStackView = UIStackView()

    private var blockViews = [ArgBlock]()

    init(contents: [ArgContentType], visualCodeEditorController: VisualCodeEditorController) {

        self.contents = contents

        super.init(frame: CGRect())

        if #available(iOS 13, *) {
            self.backgroundColor = .vplBackground
        } else {
            self.backgroundColor = .white
        }
        //self.layer.borderColor = UIColor.black.cgColor
        //self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false

        contentsStackView.axis = .horizontal
        contentsStackView.alignment = .center
        contentsStackView.spacing = ArgView.spaceBetweenContents
        self.addSubview(contentsStackView)
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    contentsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
                    contentsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
                    contentsStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ArgView.spaceBetweenContents),
                    contentsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -ArgView.spaceBetweenContents),

                    contentsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
                    contentsStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
                ]
        )


        var contentIndex = 0
        for content in contents {
            switch content {
            case .Text(let text):
                let label = ArgText(value: text, stackView: self.contentsStackView, index: contentIndex, visualCodeEditorController: visualCodeEditorController)

                label.delegate = visualCodeEditorController

                contentsStackView.addArrangedSubview(label)

            case .Block(let blockData):
                //TODO:
                let block = ArgBlock(blockData: blockData, stackView: self.contentsStackView, index: contentIndex, visualCodeEditorController: visualCodeEditorController)

                block.delegate = visualCodeEditorController

                contentsStackView.addArrangedSubview(block)

                self.blockViews.append(block)

                break
            }

            contentIndex += 1
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func getCodeStr() -> String {
        var codeStr = ""

        for content in self.contentsStackView.arrangedSubviews {
            if let argText = content as? ArgText {
                codeStr += argText.getCodeStr()
            }
            if let argBlock = content as? ArgBlock {
                codeStr += argBlock.getCodeStr()
            }
        }

        return codeStr
    }

    func findArgViewStack(argContentView: ArgContent) -> UIStackView? {
        let center = argContentView.superview!.convert(argContentView.center, to: self.contentsStackView)

        for block in self.blockViews {
            if block.frame.contains(center) {
                if let stackView = block.findArgViewStack(argContentView: argContentView) {
                    return stackView
                } else {
                    return self.contentsStackView
                }
            }
        }

        return self.contentsStackView
    }
}
