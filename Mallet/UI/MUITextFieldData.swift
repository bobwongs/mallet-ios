//
//  MUITextFieldData.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUITextFieldData: Codable {

    var enabled = true

    var text: String

    var placeholder: String

    var color: MUIColor

    var size: CGFloat

    var alignment: MUITextAlignment

    static let disabled = MUITextFieldData(enabled: false, text: "", placeholder: "", color: .clear, size: 0, alignment: .center)

    static let defaulValue = MUITextFieldData(text: "Text", placeholder: "", color: .black, size: 17, alignment: .leading)

}
