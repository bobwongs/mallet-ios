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

    @State var keyboardHeight: CGFloat = 0

    let bottomInset: CGFloat

    let closeEditor: () -> Void

    private var uiDataBinding: Binding<MUI> {
        self.editorViewModel.getSelectedUIData()
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
                    .onReceive(
                        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                        self.keyboardWillShow(notification)
                    }
                    .onReceive(
                        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
                        self.keyboardWillHide(notification)
                    }
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(leading: leadingItems(), trailing: trailingItems())
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            Spacer()
                .frame(height: max(bottomInset, keyboardHeight))
                .edgesIgnoringSafeArea(.bottom)
        }
            .background(Blur(style: .systemThickMaterial))
    }

    func keyboardWillShow(_ notification: Notification) {
        if showingSubEditor {
            return
        }

        guard  let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        withAnimation {
            keyboardHeight = frame.cgRectValue.height
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        if showingSubEditor {
            return
        }

        withAnimation {
            keyboardHeight = 0
        }
    }

    private func leadingItems() -> some View {
        Text(uiData.uiName)
            .fontWeight(.bold)
    }

    private func trailingItems() -> some View {
        Button(action: {
            self.onCloseEditor()
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
