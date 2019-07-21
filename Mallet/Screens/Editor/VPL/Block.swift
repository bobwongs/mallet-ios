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

public class Block: UIView {

    public var index: Int

    private var indent = 0

    private var indentViewWidthConstraint: NSLayoutConstraint

    private let indentWidth: CGFloat = 30

    init(blockData: BlockData, index: Int) {

        self.index = index

        let indentView = UIView()
        indentView.translatesAutoresizingMaskIntoConstraints = false
        indentViewWidthConstraint = NSLayoutConstraint(item: indentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: indentWidth * CGFloat(blockData.indent))
        indentView.addConstraint(indentViewWidthConstraint)

        super.init(frame: CGRect())
        self.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        let blockView = UIView()
        blockView.layer.cornerRadius = 10
        blockView.layer.shadowOffset = CGSize(width: 0, height: 2)
        blockView.layer.shadowColor = UIColor.black.cgColor
        blockView.layer.shadowOpacity = 0.5
        blockView.layer.shadowRadius = 3

        let blockStackView = UIStackView(frame: CGRect())
        blockStackView.axis = .horizontal
        blockStackView.distribution = .fill
        blockStackView.spacing = 5

        stackView.addArrangedSubview(indentView)
        stackView.addArrangedSubview(blockView)

        blockView.translatesAutoresizingMaskIntoConstraints = false

        blockView.addSubview(blockStackView)
        let paddingV: CGFloat = 7
        let paddingH: CGFloat = 7

        blockStackView.translatesAutoresizingMaskIntoConstraints = false
        blockStackView.topAnchor.constraint(equalTo: blockView.topAnchor, constant: paddingV).isActive = true
        blockStackView.bottomAnchor.constraint(equalTo: blockView.bottomAnchor, constant: -paddingV).isActive = true
        blockStackView.leadingAnchor.constraint(equalTo: blockView.leadingAnchor, constant: paddingH).isActive = true
        blockStackView.trailingAnchor.constraint(equalTo: blockView.trailingAnchor, constant: -paddingH).isActive = true

        blockStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        var width: CGFloat = 0

        blockView.backgroundColor = UIColor.gray

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

    public func changeIndent(by: Int) {

    }
}
