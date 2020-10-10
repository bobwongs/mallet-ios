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

    @Binding var showingSubEditor: Bool

    var body: some View {
        Group {
            if textData.enabled {
                ListSection(title: "Text") {
                    TextInputCell(text: self.$textData.text, title: "Text", symbol: "text.justify", placeholder: "Text")

                    ColorInputCell(color: self.$textData.color, title: "Color", symbol: "paintpalette", showingSubEditor: self.$showingSubEditor)

                    NumberInputCell(value: self.$textData.size, range: 0.1...1000, title: "Size", symbol: "magnifyingglass")

                    TextAlignmentInputCell(alignment: self.$textData.alignment, title: "Alignment", symbol: "text.alignleft")
                }
            }
        }
    }
}

extension TextStyleEditorView: Equatable {

    public static func ==(lhs: TextStyleEditorView, rhs: TextStyleEditorView) -> Bool {
        lhs.textData == rhs.textData &&
            lhs.showingSubEditor == rhs.showingSubEditor
    }

}
