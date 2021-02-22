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

    let appViewGeo: GeometryProxy

    private var editingText: Bool {
        editorViewModel.textEditingUIID == uiData.uiID
    }

    init(uiData: Binding<MUI>, appViewGeo: GeometryProxy, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frameData.frame

        self.appViewGeo = appViewGeo

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
                GeometryReader { geo in
                    if editorViewModel.selectedUIID == uiData.uiID {
                        if editingText {
                            EditorTextView(backgroundData: self.$uiData.backgroundData, textData: self.$uiData.textData)
                                .gesture(TapGesture())
                        } else {
                            Rectangle()
                                .gesture(DragGesture(minimumDistance: 0.5)
                                             .onChanged { value in
                                                 self.frame.x += value.translation.width
                                                 self.frame.y += value.translation.height
                                                 selectUI(geo)
                                             }
                                             .onEnded { _ in
                                                 print(editorViewModel.findUIPosInGrid(uiGeo: geo, appViewGeo: appViewGeo))
                                             }
                                )
                                .gesture(TapGesture()
                                             .onEnded {
                                                 if uiData.textData.enabled {
                                                     editorViewModel.editUIText(id: uiData.uiID)
                                                 }
                                             })
                        }
                    } else {
                        Rectangle()
                            .gesture(TapGesture()
                                         .onEnded {
                                             selectUI(geo)
                                         }
                            )
                    }
                }
                    .foregroundColor(Color.white.opacity(0.001))
            )
            .position(x: frame.midX, y: frame.midY)
    }

    private func selectUI(_ geo: GeometryProxy) {
        editorViewModel.selectUI(id: uiData.uiID, frame: geo.frame(in: .global))
    }
}
