//
//  CodeEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct CodeEditorView: View {

    enum EditorMode {
        case text
        case tremolo
    }

    @Environment(\.presentationMode) var presentationMode

    @Binding var uiData: MUI

    @State private var mode = EditorMode.tremolo

    @State var text = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if mode == .text {
                    TextEditorView(uiData: $uiData)
                } else {
                    TremoloEditorView(uiData: $uiData)
                }
            }
                .navigationBarTitle(Text(uiData.uiName), displayMode: .inline)
                .navigationBarItems(leading: leadingBarItems(),
                                    trailing: trailingBarItems())
        }
    }

    private func leadingBarItems() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .fontWeight(.semibold)
                .padding(.vertical, 7)
        }
    }

    private func trailingBarItems() -> some View {
        Button(action: {
            if mode == .text {
                self.mode = .tremolo
            } else {
                self.mode = .text
            }
        }) {
            Group {
                if mode == .text {
                    Image(systemName: "rectangle.grid.1x2.fill")
                } else {
                    Image(systemName: "text.alignleft")
                }
            }
                .padding(.vertical, 7)
                .padding(.trailing, 5)
        }
    }

}