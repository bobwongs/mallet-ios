//
//  EditorUIOverlayView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorUIOverlayView<Content: View>: View {

    let content: () -> Content

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var uiData: MUI

    @Binding var frame: MUIRect

    private var editingText: Bool {
        editorViewModel.textEditingUIID == uiData.uiID
    }

    init(uiData: Binding<MUI>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frameData.frame

        self.content = content
    }

    var body: some View {
        Group {
            if editingText {
                content()
                    .hidden()
            } else {
                content()
            }
        }
            .overlay(
                Group {
                    if editorViewModel.selectedUIID == uiData.uiID {
                        if (editingText) {
                            if uiData.textData.enabled {
                                EditorTextView(backgroundData: $uiData.backgroundData, textData: $uiData.textData)
                                    .gesture(TapGesture())
                            } else if uiData.textFieldData.enabled {
                                content()
                                    .gesture(TapGesture())
                            }
                        } else {
                            Rectangle()
                                .gesture(DragGesture(minimumDistance: 0.5)
                                             .onChanged { value in
                                                 self.frame.x += value.translation.width
                                                 self.frame.y += value.translation.height
                                                 self.editorViewModel.selectUI(id: self.uiData.uiID)
                                             })
                                .gesture(TapGesture()
                                             .onEnded {
                                                 if self.uiData.textData.enabled || self.uiData.textFieldData.enabled {
                                                     self.editorViewModel.editUIText(id: self.uiData.uiID)
                                                 }
                                             })
                        }
                    } else {
                        Rectangle()
                            .gesture(TapGesture()
                                         .onEnded {
                                             self.editorViewModel.selectUI(id: self.uiData.uiID)
                                             if self.uiData.textFieldData.enabled {
                                                 self.editorViewModel.editUIText(id: self.uiData.uiID)
                                             }
                                         }
                            )
                    }
                }
                    .foregroundColor(Color.white.opacity(0.001))
            )
            .background(Color.black.opacity(0.05))
            .position(x: frame.midX, y: frame.midY)
    }
}
