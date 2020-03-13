//
//  UIStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UIStyleEditorView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    let closeEditor: () -> Void

    private var uiDataBinding: Binding<MUI> {
        self.editorViewModel.getSelectedUIData()
    }

    private var uiData: MUI {
        editorViewModel.getSelectedUIData().wrappedValue
    }

    var body: some View {
        VStack {
            topBar()

            List {
                if editorViewModel.selectedUIID != nil {
                    Group {
                        HStack {
                            Text("Name")
                            TextField("UI Name", text: uiDataBinding.uiName)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
        }
            .background(Blur(style: .systemThickMaterial))
    }

    private func topBar() -> some View {
        HStack {
            Text(uiData.uiName)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                self.onCloseEditor()
            }) {
                Text("Done")
                    .fontWeight(.semibold)
            }
        }
            .frame(height: 40)
            .padding([.leading, .trailing], 15)
    }

    private func textDataEditor() -> some View {
        Group {
            if uiData.textData.enabled {
                Group {
                    HStack {
                        Text("Text:")
                        TextField("Text", text: uiDataBinding.textData.text)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Size:")
                        TextField("17", value: uiDataBinding.textData.size, formatter: NumberFormatter())
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }

    private func onCloseEditor() {
        closeEditor()
    }
}
