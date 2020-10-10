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

    @State var showingSubEditor = false

    let bottomInset: CGFloat

    let closeEditor: () -> Void

    private var uiDataBinding: Binding<MUI> {
        editorViewModel.getSelectedUIData()
    }

    private var uiData: MUI {
        editorViewModel.getSelectedUIData().wrappedValue
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                ScrollView {
                    if editorViewModel.selectedUIID != nil {
                        VStack(spacing: 0) {
                            generalInfo()

                            FrameStyleEditorView(frameData: uiDataBinding.frameData)
                                .equatable()

                            BackgroundStyleEditorView(backgroundData: uiDataBinding.backgroundData, showingSubEditor: $showingSubEditor)
                                .equatable()

                            ArrangementInputCell()
                                .environmentObject(editorViewModel)

                            TextStyleEditorView(textData: uiDataBinding.textData, showingSubEditor: $showingSubEditor)
                                .equatable()

                            TextFieldStyleEditorView(textFieldData: uiDataBinding.textFieldData, showingSubEditor: $showingSubEditor)
                                .equatable()

                            ButtonStyleEditorView(buttonData: uiDataBinding.buttonData)
                                .equatable()

                            SliderStyleEditorView(sliderData: uiDataBinding.sliderData)
                                .equatable()

                            ToggleStyleEditorView(toggleData: uiDataBinding.toggleData)
                                .equatable()
                        }
                    }
                }
                    .id(uiData.uiID)
                    .navigationBarTitle(uiData.uiName, displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            trailingItems()
                        }
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            Spacer()
                .frame(height: bottomInset)
        }
            .background(Blur(style: .systemThickMaterial))
    }

    private func leadingItems() -> some View {
        Text(uiData.uiName)
            .fontWeight(.bold)
    }

    private func trailingItems() -> some View {
        Button(action: {
            onCloseEditor()
        }) {
            Text("Done")
                .fontWeight(.semibold)
        }
    }

    private func generalInfo() -> some View {
        TextInputCell(text: uiDataBinding.uiName, title: "Name", placeholder: "UI Name")
    }

    private func onCloseEditor() {
        closeEditor()
    }
}
