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

    @Binding var uiData: MUI

    @Binding var frame: MUIRect

    @Binding var selectedUIID: Int?

    @State private var showUISettings = false

    @State private var editingText = false

    init(uiData: Binding<MUI>, selectedUIID: Binding<Int?>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frameData.frame

        self._selectedUIID = selectedUIID

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
            .background(Color.black.opacity(0.05))
            .overlay(
                Group {
                    if selectedUIID == uiData.uiID {
                        if (editingText) {
                            EditorTextView(backgroundData: $uiData.backgroundData, textData: $uiData.textData)
                                .gesture(TapGesture())
                        } else {
                            Rectangle()
                                .highPriorityGesture(DragGesture(minimumDistance: 0.5)
                                                         .onChanged { value in
                                                             self.frame.x += value.translation.width
                                                             self.frame.y += value.translation.height
                                                             self.setSelectedUIID()
                                                         })
                                .gesture(TapGesture()
                                             .onEnded {
                                                 if self.uiData.textData.enabled {
                                                     self.editingText = true
                                                 }
                                             })
                        }
                    } else {
                        Rectangle()
                            .gesture(TapGesture()
                                         .onEnded {
                                             self.setSelectedUIID()
                                         }
                            )
                    }
                }
                    .foregroundColor(Color.white.opacity(0.001))
            )
            .position(x: frame.midX, y: frame.midY)
            .sheet(isPresented: $showUISettings) {
                UISettingsView(uiData: self.$uiData)
            }
    }

    private func setSelectedUIID() {
        selectedUIID = uiData.uiID
    }
}
