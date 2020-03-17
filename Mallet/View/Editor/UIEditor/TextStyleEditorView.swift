//
//  TextStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextStyleEditorView: View {

    @Binding var textData: MUITextData

    var body: some View {
        Group {
            if textData.enabled {
                ListSection(title: "Text") {
                    TextInputCell(text: self.$textData.text, title: "Text", placeholder: "Text")

                    ColorInputCell(color: self.$textData.color, title: "Color")

                    NumberInputCell(value: self.$textData.size, range: 0.1...1000, title: "Size")

                    TextAlignmentInputCell(alignment: self.$textData.alignment, title: "Alignment")
                }
            }
        }
    }
}
