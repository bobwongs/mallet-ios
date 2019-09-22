//
//  VariableView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/09.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class Variable: UIView {

    init(variableName: String) {
        super.init(frame: CGRect())

        let label = UILabel()
        label.text = variableName
        label.textColor = .black

        self.addSubview(label)
        self.sizeToFit()

        let a = UITextField()

        self.backgroundColor = .gray
        self.layer.cornerRadius = self.layer.frame.size.height / 2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
