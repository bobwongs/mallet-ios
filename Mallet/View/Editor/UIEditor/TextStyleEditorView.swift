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
                UIStyleEditorSectionView(title: "Text") {
                    TextEditView(text: self.$textData.text, title: "Text", placeholder: "Text")

                    ColorEditView(color: self.$textData.color)

                    TextSizeEditView(size: self.$textData.size)

                    TextAlignmentEditView(alignment: self.$textData.alignment)
                }
            }
        }
    }
}

struct TextEditView: View {

    @Binding var text: String

    let title: String

    let placeholder: String

    var body: some View {
        HStack {
            Text(title)
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct ColorEditView: View {

    @Binding var color: MUIColor

    var body: some View {

        HStack {
            Text("Color")

            Spacer()

            Rectangle()
                .background(color.toColor)
                .frame(width: 30)
                .cornerRadius(5)
        }
    }
}

struct TextSizeEditView: View {

    @Binding var size: CGFloat

    var body: some View {
        HStack {
            Text("Size")
            NumberInputView(value: self.$size, range: 0.1...1000)
        }
    }
}

struct TextAlignmentEditView: View {

    @Binding var alignment: MUITextAlignment

    var body: some View {
        HStack {
            Text("Alignment")

            Spacer()

            HStack(spacing: 5) {
                Group {
                    alignmentButton(image: "text.alignleft", alignment: .leading)

                    alignmentButton(image: "text.aligncenter", alignment: .center)

                    alignmentButton(image: "text.alignright", alignment: .trailing)
                }
                    .cornerRadius(5)
            }
        }
    }

    private func alignmentButton(image: String, alignment: MUITextAlignment) -> some View {
        Image(systemName: image)
            .onTapGesture {
                self.alignment = alignment
            }
            .padding(10)
            .background(
                Group {
                    if self.alignment == alignment {
                        Color.blue
                    } else {
                        Color(.tertiarySystemFill)
                    }
                }
            )
    }

}