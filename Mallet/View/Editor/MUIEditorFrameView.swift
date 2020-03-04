//
//  MUIEditorFrameView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MEditorFrameView<Content>: View where Content: View {

    let content: () -> Content

    @Binding var uiData: MUI

    @Binding var frame: MRect

    @Binding var selectedUIID: Int?

    init(uiData: Binding<MUI>, selectedUIID: Binding<Int?>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frame

        self._selectedUIID = selectedUIID

        self.content = content
    }

    var body: some View {
        content()
            .frame(width: frame.width, height: frame.height)
            .background(Color.black.opacity(0.05))
            .position(x: frame.midX, y: frame.midY)
            .overlay(
                Rectangle()
                    .gesture(DragGesture(minimumDistance: 0)
                                 .onChanged { value in
                                     self.frame.x += value.translation.width
                                     self.frame.y += value.translation.height
                                     self.setSelectedUIID()
                                 })
                    .gesture(TapGesture()
                                 .onEnded {
                                     self.setSelectedUIID()
                                 }
                    )
                    .foregroundColor(Color.white.opacity(0.001))
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
            )
    }

    private func setSelectedUIID() {
        selectedUIID = uiData.uiID
    }
}
