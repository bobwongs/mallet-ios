//
//  Block.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public struct BlockContentData {
    let type: Int
    let value: String
}

public struct BlockData {
    let contents: [BlockContentData]
    let indent: Int
}

public class Block: UIStackView {

    public var index: Int

    private var indentConstraint = NSLayoutConstraint()

    private var indent: Int

    init(blockData: BlockData, index: Int) {

        self.indent = blockData.indent
        self.index = index

        super.init(frame: CGRect())

        self.translatesAutoresizingMaskIntoConstraints = false

        let blankView = UIView()
        blankView.translatesAutoresizingMaskIntoConstraints = false

        self.addArrangedSubview(blankView)

        let indentConstraint = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 50 * CGFloat(indent))
        self.indentConstraint = indentConstraint
        self.addConstraint(indentConstraint)

        self.addArrangedSubview(BlockWithoutIndent(blockData: blockData, index: index))
    }

    /*
required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
*/


    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public func changeBlockIndent(direction: Int) {

        self.layoutIfNeeded()

        indent += direction

        indentConstraint.constant = 50 * CGFloat(indent)

        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
        })
    }
}

public class BlockWithoutIndent: UIView {

    public var indentConstraint = NSLayoutConstraint()

    public var index: Int

    private var indent: Int

    init(blockData: BlockData, index: Int) {

        self.index = index
        self.indent = blockData.indent

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


        for i in blockData.contents {

            switch i.type {
            case 0:
                let text = UILabel()
                text.text = i.value
                text.textColor = UIColor.white
                text.textAlignment = .center

                text.sizeToFit()

                width += text.frame.width + 10

                blockStackView.addArrangedSubview(text)

            case 1:
                let textField = UITextField()

                textField.text = i.value
                textField.textColor = UIColor.black
                textField.backgroundColor = UIColor.white
                textField.textAlignment = .center
                textField.layer.cornerRadius = 5

                textField.sizeToFit()

                width += textField.frame.width + 10

                blockStackView.addArrangedSubview(textField)

            default:
                break
            }

            if i.type == 0 {

            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
