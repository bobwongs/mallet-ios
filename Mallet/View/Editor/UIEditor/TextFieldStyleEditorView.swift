//
//  TextFieldStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextFieldStyleEditorView: View {

    @Binding var textFieldData: MUITextFieldData

    @Binding var showingSubEditor: Bool

    var body: some View {
        Group {
            if textFieldData.enabled {
                ListSection(title: "Text Field") {
                    TextInputCell(text: self.$textFieldData.text, title: "Text", placeholder: "Text")

                    TextInputCell(text: self.$textFieldData.placeholder, title: "Placeholder", placeholder: "Placeholder")

                    ColorInputCell(color: self.$textFieldData.color, title: "Color", showingSubEditor: self.$showingSubEditor)

                    NumberInputCell(value: self.$textFieldData.size, range: 0.1...1000, title: "Size")

                    TextAlignmentInputCell(alignment: self.$textFieldData.alignment, title: "Alignment")
                }
            }
        }
    }
}
