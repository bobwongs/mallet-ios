//
//  ArrangementInputCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/18.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ArrangementInputCell: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    var body: some View {
        ListCell {
            HStack {
                Label("Arrangement", systemImage: "square.3.stack.3d")

                Spacer()

                HStack(spacing: 5) {
                    arrangementButton(image: "arrow.down.to.line.alt", action: { editorViewModel.moveToBack() })

                    arrangementButton(image: "arrow.down", action: { editorViewModel.moveBackward() })

                    arrangementButton(image: "arrow.up", action: { editorViewModel.moveForward() })

                    arrangementButton(image: "arrow.up.to.line.alt", action: { editorViewModel.moveToFront() })
                }
            }
        }
    }

    private func arrangementButton(image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: image)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .foregroundColor(.primary)
        }
            .background(Color(.tertiarySystemFill))
            .cornerRadius(5)
    }


}