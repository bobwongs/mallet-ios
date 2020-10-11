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
                    TextInputCell(text: self.$textFieldData.text, title: "Text", symbol: "pencil", placeholder: "Text")

                    TextInputCell(text: self.$textFieldData.placeholder, title: "Placeholder", symbol: "pencil", placeholder: "Placeholder")

                    ColorInputCell(color: self.$textFieldData.color, title: "Color", symbol: "paintpalette", showingSubEditor: self.$showingSubEditor)

                    NumberInputCell(value: self.$textFieldData.size, range: 0.1...1000, title: "Size", symbol: "magnifyingglass")

                    TextAlignmentInputCell(alignment: self.$textFieldData.alignment, title: "Alignment", symbol: "text.alignleft")
                }
            }
        }
    }
}

extension TextFieldStyleEditorView: Equatable {

    static func ==(lhs: TextFieldStyleEditorView, rhs: TextFieldStyleEditorView) -> Bool {
        lhs.textFieldData == rhs.textFieldData &&
            lhs.showingSubEditor == rhs.showingSubEditor
    }

}
