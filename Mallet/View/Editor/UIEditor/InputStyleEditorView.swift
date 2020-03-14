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
                    TextEditView(text: self.$inputData.text, title: "Text", placeholder: "Text")

                    TextEditView(text: self.$inputData.placeholder, title: "Placeholder", placeholder: "Placeholder")

                    ColorEditView(color: self.$inputData.color)

                    TextSizeEditView(size: self.$inputData.size)

                    TextAlignmentEditView(alignment: self.$inputData.alignment)
                }
            }
        }
    }
}
