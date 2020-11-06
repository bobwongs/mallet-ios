//
//  EditorAppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorAppView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var appViewScale: CGFloat

    var body: some View {
        ZStack {
            Color.white

            grid()

            ForEach(editorViewModel.uiIDs, id: \.self) { id in
                EditorUIOverlayView(uiData: editorViewModel.getUIDataOf(id)) {
                    //self.generateUI(id: id)
                    MUI.generateView(uiData: editorViewModel.getUIDataOf(id))
                }
                    .environmentObject(editorViewModel)
            }

            ForEach(editorViewModel.uiIDs, id: \.self) { id in
                Group {
                    if id == editorViewModel.selectedUIID {
                        UIFrameEditingView(uiData: editorViewModel.getUIDataOf(id),
                                           appViewScale: self.$appViewScale) {
                            MUI.generateView(uiData: editorViewModel.getUIDataOf(id))
                        }
                            .environmentObject(editorViewModel)
                    }
                }
            }
        }
            .background(
                Color.white.opacity(0.001)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 2000, height: 2000)
                    .onTapGesture {
                        editorViewModel.deselectUI()
                    }
            )
            .colorScheme(.light)
            .onTapGesture {
                editorViewModel.deselectUI()
            }
    }

    private func grid() -> some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(0..<editorViewModel.screen.gridW, id: \.self) { _ in
                    Color.white
                        .hidden()
                        .border(Color.black, width: 0.5)
                }
            }
            VStack(spacing: 0) {
                ForEach(0..<editorViewModel.screen.gridH, id: \.self) { _ in
                    Color.white
                        .hidden()
                        .border(Color.black, width: 0.5)
                }
            }
        }
    }

}
