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

    @Binding var frame: MUIRect

    @Binding var selectedUIID: Int?

    @Binding var appViewScale: CGFloat

    @State private var showUISettings = false

    @State private var editingText = false

    private var borderWidth: CGFloat {
        1 / self.appViewScale
    }

    init(uiData: Binding<MUI>, selectedUIID: Binding<Int?>, appViewScale: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frameData.frame

        self._selectedUIID = selectedUIID

        self._appViewScale = appViewScale

        self.content = content
    }

    var body: some View {
        Group {
            if editingText {
                Group {
                    if uiData.frameData.lockWidth && uiData.frameData.lockHeight {
                        content()
                    } else if uiData.frameData.lockWidth {
                        content()
                            .frame(height: frame.height)
                    } else if uiData.frameData.lockHeight {
                        content()
                            .frame(width: frame.width)
                    } else {
                        content()
                            .frame(width: frame.width, height: frame.height)
                    }
                }
                    .hidden()
            } else {
                Group {
                    if uiData.frameData.lockWidth && uiData.frameData.lockHeight {
                        content()
                    } else if uiData.frameData.lockWidth {
                        content()
                            .frame(height: frame.height)
                    } else if uiData.frameData.lockHeight {
                        content()
                            .frame(width: frame.width)
                    } else {
                        content()
                            .frame(width: frame.width, height: frame.height)
                    }
                }
                    .background(uiData.backgroundData.color.toColor)
                    .cornerRadius(uiData.backgroundData.cornerRadius)
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
                                .padding(self.borderWidth / 2)
                                .border(Color.blue, width: self.borderWidth)
                                .gesture(DragGesture(minimumDistance: 0.5)
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
