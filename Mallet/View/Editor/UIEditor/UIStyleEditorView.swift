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

            List {
                if editorViewModel.selectedUIID != nil {
                    generalInfo()

                    FrameStyleEditorView(frameData: uiDataBinding.frameData)

                    BackgroundStyleEditorView(backgroundData: uiDataBinding.backgroundData)

                    TextStyleEditorView(textData: uiDataBinding.textData)

                    TextFieldStyleEditorView(textFieldData: uiDataBinding.textFieldData)

                    SliderStyleEditorView(sliderData: uiDataBinding.sliderData)

                    ToggleStyleEditorView(toggleData: uiDataBinding.toggleData)
                }
            }
                .id(uiData.uiID)
                .onReceive(
                    NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
                    self.keyboardWillChangeFrame(notification)
                }

            Spacer()
                .frame(height: max(bottomInset, keyboardHeight))
                .edgesIgnoringSafeArea(.bottom)
        }
            .background(Blur(style: .systemThickMaterial))
    }

    func keyboardWillChangeFrame(_ notification: Notification) {
        guard  let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }

        guard  let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        withAnimation {
            keyboardHeight = max(0, beginFrame.cgRectValue.minY - endFrame.cgRectValue.minY)
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
