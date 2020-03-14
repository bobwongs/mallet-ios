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
        VStack(spacing: 0) {
            topBar()

            List {
                if editorViewModel.selectedUIID != nil {
                    generalInfo()

                    FrameStyleEditorView(frameData: uiDataBinding.frameData)

                    BackgroundStyleEditorView(backgroundData: uiDataBinding.backgroundData)

                    TextStyleEditorView(textData: uiDataBinding.textData)

                    InputStyleEditorView(inputData: uiDataBinding.inputData)

                    SliderStyleEditorView(sliderData: uiDataBinding.sliderData)
                }
            }
        }
            .background(Blur(style: .systemThickMaterial))
    }

    private func topBar() -> some View {
        HStack(alignment: .center) {
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

    private func generalInfo() -> some View {
        HStack {
            Text("Name")
            TextField("UI Name", text: uiDataBinding.uiName)
                .multilineTextAlignment(.trailing)
        }
    }

    private func onCloseEditor() {
        closeEditor()
    }
}
