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
                Text("Arrangement")

                Spacer()

                HStack(spacing: 5) {
                    self.arrangementButton(image: "arrow.down.to.line.alt", action: { self.editorViewModel.moveToBack() })

                    self.arrangementButton(image: "arrow.down", action: { self.editorViewModel.moveBackward() })

                    self.arrangementButton(image: "arrow.up", action: { self.editorViewModel.moveForward() })

                    self.arrangementButton(image: "arrow.up.to.line.alt", action: { self.editorViewModel.moveToFront() })
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