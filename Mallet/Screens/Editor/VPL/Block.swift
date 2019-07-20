//
//  Block.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

public struct BlockData {
    let type: Int
    let value: String
}

public class Block: UIView {

    var index: Int

    init(blockData: [BlockData], index: Int) {

        self.index = index

        super.init(frame: CGRect())


        self.layer.cornerRadius = 10

        self.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(frame: CGRect())
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10

        self.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true

        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true


        var width: CGFloat = 0

        self.backgroundColor = UIColor.purple

        for i in blockData {

            switch i.type {
            case 0:
                let text = UILabel()
                text.text = i.value
                text.textColor = UIColor.white
                text.textAlignment = .center

                text.sizeToFit()

                width += text.frame.width + 10

                stackView.addArrangedSubview(text)

            case 1:
                let textField = UITextField()

                textField.text = i.value
                textField.textColor = UIColor.black
                textField.backgroundColor = UIColor.white
                textField.textAlignment = .center
                textField.layer.cornerRadius = 5

                textField.sizeToFit()

                width += textField.frame.width + 10

                stackView.addArrangedSubview(textField)

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
