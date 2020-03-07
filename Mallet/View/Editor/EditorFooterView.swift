//
//  EditorFooterView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorFooterView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var appViewScale: CGFloat

    @Binding var appViewOffset: CGPoint

    let editorGeo: GeometryProxy

    @State private var modalOffset: CGFloat = 0

    @State private var selectedUIType: MUIType = .space

    @State private var selectedUIFrame = CGRect.zero

    @State private var showingFooter = true

    var body: some View {
        GeometryReader { geo in
            ZStack {
                SemiModalView(height: 200, minHeight: 40, offset: self.$modalOffset) {
                    UISelectionView(editorGeo: self.editorGeo,
                                    closeModalView: { self.closeModalView() },
                                    selectedUIType: self.$selectedUIType,
                                    selectedUIFrame: self.$selectedUIFrame,
                                    appViewScale: self.$appViewScale,
                                    appViewOffset: self.$appViewOffset
                    )
                }

                EditorToolBar(offset: self.$modalOffset, height: 40)
                    .environmentObject(self.editorViewModel)

                if self.selectedUIType != .space {
                    UISelectionView.generateUI(type: self.selectedUIType)
                        .environmentObject(self.editorViewModel)
                        .scaleEffect(self.appViewScale)
                        .frame(width: self.selectedUIFrame.width, height: self.selectedUIFrame.height)
                        .position(x: self.selectedUIFrame.midX - geo.frame(in: .global).origin.x,
                                  y: self.selectedUIFrame.midY - geo.frame(in: .global).origin.y)
                }
            }
        }
    }

    private func closeModalView() {
        withAnimation(.easeOut(duration: 0.2)) {
            self.modalOffset = 0
        }
    }
}
