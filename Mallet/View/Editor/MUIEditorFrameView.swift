//
//  MUIEditorFrameView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIEditorFrameView<Content>: View where Content: View {

    let content: () -> Content

    @Binding var uiData: MUI

    @Binding var frame: MRect

    @Binding var selectedUIID: Int?

    @State private var showUISettings = false

    @State private var editingText = false

    @State private var text = "Yay"

    init(uiData: Binding<MUI>, selectedUIID: Binding<Int?>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frame

        self._selectedUIID = selectedUIID

        self.content = content
    }

    var body: some View {
        Group {
            if editingText {
                Spacer()
            } else {
                content()
            }
        }
            .frame(width: frame.width, height: frame.height)
            .background(Color.black.opacity(0.05))
            .position(x: frame.midX, y: frame.midY)
            .overlay(
                Group {
                    if selectedUIID == uiData.uiID {
                        if (editingText) {
                            EditorTextView(textData: $uiData.textData)
                                .gesture(TapGesture())
                        } else {
                            Rectangle()
                                .gesture(DragGesture(minimumDistance: 0.5)
                                             .onChanged { value in
                                                 self.frame.x += value.translation.width
                                                 self.frame.y += value.translation.height
                                                 self.setSelectedUIID()
                                             })
                                .gesture(TapGesture()
                                             .onEnded {
                                                 self.editingText = true
                                                 //self.showUISettings = true
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
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
            )
            .sheet(isPresented: $showUISettings) {
                UISettingsView(uiData: self.$uiData)
            }
    }

    private func setSelectedUIID() {
        selectedUIID = uiData.uiID
    }
}
