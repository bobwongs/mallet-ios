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
        HStack {
            Text(title)

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
