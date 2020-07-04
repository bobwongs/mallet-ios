//
//  TextEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextEditorView: View {

    @Binding private var uiData: MUI

    @State private var selectedCodeIdx = 0

    // workaround?
    @State private var selectedCode = ""

    private let codes: [Binding<MUIAction>]

    init(uiData: Binding<MUI>) {
        self._uiData = uiData
        self.codes = MUI.getCode(from: uiData)
    }

    var body: some View {
        Group {
            if codes.count == 0 {
                Text("There is no code to edit.")
            } else {
                VStack(spacing: 0) {
                    codeTabView()
                    TextEditorTextView(text: $selectedCode)
                        .onChange(of: selectedCode) { _ in
                            codes[selectedCodeIdx].code.wrappedValue = selectedCode
                        }
                }
            }
        }
    }

    private func codeTabView() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(0..<codes.count, id: \.self) { idx in
                    Button(action: {
                        selectedCodeIdx = idx
                        selectedCode = codes[selectedCodeIdx].code.wrappedValue
                    }) {
                        Text(self.codes[idx].wrappedValue.name)
                            .padding(.horizontal, 10)
                            .foregroundColor(.primary)
                    }
                        .frame(height: 30)
                        .background(
                            Group {
                                if self.selectedCodeIdx == idx {
                                    Color.gray.opacity(0.2)
                                } else {
                                    Color.gray.opacity(0.1)
                                }
                            }
                        )
                }
            }
        }
    }

}
