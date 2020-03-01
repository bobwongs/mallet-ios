//
//  EditorModalView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorModalView: View {

    @State var initialDragAmount: CGFloat = 230 // modalHeight - minVisibleHeight

    @State var dragAmount: CGFloat = 230

    @State var selectedUIType: MUIType = .space

    @State var selectedUIFrame = CGRect.zero

    private let modalHeight: CGFloat = 300

    private let maxVisibleHeight: CGFloat = 300

    private let minVisibleHeight: CGFloat = 70 //controlBarHeight + 40

    private let controlBarHeight: CGFloat = 30

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer()
                    self.modal(geo: geo)
                }

                if self.selectedUIType != .space {
                    MUISelectionView.generateUI(type: self.selectedUIType)
                        .frame(width: self.selectedUIFrame.width, height: self.selectedUIFrame.height)
                        .position(x: self.selectedUIFrame.midX - geo.frame(in: .global).origin.x,
                                  y: self.selectedUIFrame.midY - geo.frame(in: .global).origin.y)
                }
            }
        }
    }

    private func modal(geo: GeometryProxy) -> some View {
        VStack {
            VStack {
                VStack {
                    Rectangle()
                        .frame(width: 40, height: 4)
                        .cornerRadius(2)
                        .foregroundColor(Color(.systemGray3))
                }
                    .frame(height: self.controlBarHeight)

                MUISelectionView(selectedUIType: self.$selectedUIType, selectedUIFrame: self.$selectedUIFrame)
            }
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.opaqueSeparator), lineWidth: 0.2)
                )
                .gesture(DragGesture(coordinateSpace: .global)
                             .onChanged({ value in
                                 self.dragAmount = max(self.modalHeight - self.maxVisibleHeight, min(self.modalHeight - self.minVisibleHeight, self.initialDragAmount + value.translation.height))
                             })
                             .onEnded({
                                 value in
                                 withAnimation(.easeOut(duration: 0.2)) {
                                     if value.translation.height < 0 {
                                         self.dragAmount = self.modalHeight - self.maxVisibleHeight
                                     } else {
                                         self.dragAmount = self.modalHeight - self.minVisibleHeight
                                     }
                                 }

                                 self.initialDragAmount = self.dragAmount
                             })
                )
        }
            .frame(height: self.modalHeight + geo.safeAreaInsets.bottom)
            .offset(x: 0, y: self.dragAmount)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct EditorModalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorModalView()
                .colorScheme(.light)

            EditorModalView()
                .colorScheme(.dark)
        }
    }
}
