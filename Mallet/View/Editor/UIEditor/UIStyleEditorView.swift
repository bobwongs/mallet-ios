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
            topBar()

            ScrollView {
                if editorViewModel.selectedUIID != nil {
                    VStack(spacing: 0) {
                        generalInfo()

                        FrameStyleEditorView(frameData: uiDataBinding.frameData)

                        BackgroundStyleEditorView(backgroundData: uiDataBinding.backgroundData)

                        ArrangementInputCell()
                            .environmentObject(editorViewModel)

                        TextStyleEditorView(textData: uiDataBinding.textData)

                        TextFieldStyleEditorView(textFieldData: uiDataBinding.textFieldData)

                        SliderStyleEditorView(sliderData: uiDataBinding.sliderData)

                        ToggleStyleEditorView(toggleData: uiDataBinding.toggleData)
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


            Spacer()
                .frame(height: max(bottomInset, keyboardHeight))
                .edgesIgnoringSafeArea(.bottom)
        }
            .background(Blur(style: .systemThickMaterial))
    }

    func keyboardWillShow(_ notification: Notification) {
        guard  let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        withAnimation {
            keyboardHeight = frame.cgRectValue.height
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        withAnimation {
            keyboardHeight = 0
        }
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
        TextInputCell(text: uiDataBinding.uiName, title: "Name", placeholder: "UI Name")
    }

    private func onCloseEditor() {
        closeEditor()
    }
}
