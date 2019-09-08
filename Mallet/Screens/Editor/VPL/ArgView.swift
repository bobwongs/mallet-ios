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

    static let spaceBetweenContents: CGFloat = 10.0

    private let contentsStackView = UIStackView()

    init(contents: [ArgContentType]) {

        self.contents = contents

        super.init(frame: CGRect())

        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false

        contentsStackView.axis = .horizontal
        contentsStackView.alignment = .center
        contentsStackView.spacing = ArgView.spaceBetweenContents
        self.addSubview(contentsStackView)
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    contentsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
                    contentsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
                    contentsStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ArgView.spaceBetweenContents / 2),
                    contentsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -ArgView.spaceBetweenContents / 2),
                ]
        )


        var contentIndex = 0
        for content in contents {
            switch content {
            case .Text(let text):
                let label = ArgText(value: text, stackView: self.contentsStackView)

                label.index = contentIndex

                contentsStackView.addArrangedSubview(label)

            case .Block(let blockData):
                //TODO:

                //block.index = contentIndex

                break
            }

            contentIndex += 1
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func getContentStr() -> String {
        var contentStr = ""

        for content in self.contents {
            switch content {
            case .Text(let text):
                contentStr += text

            case .Block(let blockData):

                break
            }
        }

        return contentStr
    }
}
