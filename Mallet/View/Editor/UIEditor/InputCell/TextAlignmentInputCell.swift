//
//  TextAlignmentInputCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/15.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextAlignmentInputCell: View {

    @Binding private var alignment: MUITextAlignment

    private let title: String

    init(alignment: Binding<MUITextAlignment>, title: String) {
        self._alignment = alignment

        self.title = title
    }

    var body: some View {
        ListCell {
            HStack {
                Text(self.title)

                Spacer()

                HStack(spacing: 5) {
                    self.alignmentButton(image: "text.alignleft", alignment: .leading)

                    self.alignmentButton(image: "text.aligncenter", alignment: .center)

                    self.alignmentButton(image: "text.alignright", alignment: .trailing)
                }
            }
        }
    }

    private func alignmentButton(image: String, alignment: MUITextAlignment) -> some View {
        Button(action: {
            self.alignment = alignment
        }) {
            Image(systemName: image)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .foregroundColor(.primary)
        }
            .background(
                Group {
                    if self.alignment == alignment {
                        Color.blue
                    } else {
                        Color(.tertiarySystemFill)
                    }
                }
            )
            .cornerRadius(5)
    }
}
