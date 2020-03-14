//
//  InputStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct InputStyleEditorView: View {

    @Binding var inputData: MUIInputData

    var body: some View {
        Group {
            if inputData.enabled {
                UIStyleEditorSectionView(title: "Text Field") {
                    TextInputCell(text: self.$inputData.text, title: "Text", placeholder: "Text")

                    TextInputCell(text: self.$inputData.text, title: "Placeholder", placeholder: "Placeholder")

                    ColorInputCell(color: self.$inputData.color, title: "Color")

                    NumberInputCell(value: self.$inputData.size, range: 0.1...1000, title: "Size")

                    TextAlignmentInputCell(alignment: self.$inputData.alignment, title: "Alignment")
                }
            }
        }
    }
}
