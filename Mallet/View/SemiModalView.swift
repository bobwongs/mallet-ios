//
//  SemiModalView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct SemiModalView<Content: View>: View {

    let content: () -> Content

    @Binding var offset: CGFloat

    @State private var dragGestureCurrentTranslationHeight: CGFloat = 0

    @State private var dragGestureDiffHeight: CGFloat = 0

    private let height: CGFloat

    private let minHeight: CGFloat

    private var maxOffset: CGFloat

    private let minOffset: CGFloat = 0

    private let controlBarHeight: CGFloat

    private let cornerRadius: CGFloat = 10

    init(height: CGFloat, minHeight: CGFloat, controlBarHeight: CGFloat = 30, offset: Binding<CGFloat> = .constant(0), @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.height = height + controlBarHeight
        self.minHeight = minHeight + controlBarHeight
        self.controlBarHeight = controlBarHeight
        self._offset = offset
        self.maxOffset = self.height - self.minHeight
    }

    var body: some View {
        self.modalView()
    }

    private func modalView() -> some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Rectangle()
                        .frame(width: 40, height: 4)
                        .cornerRadius(2)
                        .foregroundColor(Color(.systemGray3))
                }
                    .frame(height: self.controlBarHeight)

                self.content()
            }
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(self.cornerRadius)
                .shadow(color: Color.black.opacity(0.1), radius: 3)
                .overlay(
                    ZStack {
                        VStack {
                            Spacer()
                            Color(.tertiarySystemBackground)
                                .frame(height: self.cornerRadius)
                        }

                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .stroke(Color(.opaqueSeparator), lineWidth: 0.2)
                    }
                )
                .gesture(DragGesture(minimumDistance: 0)
                             .onChanged({ value in
                                 self.dragGestureOnChanged(value: value)
                             })
                             .onEnded({ _ in
                                 self.dragGestureOnEnded()
                             })
                )
                .onAppear {
                    self.offset = self.minOffset
                }
                .edgesIgnoringSafeArea(.bottom)
                .frame(height: self.height + geo.safeAreaInsets.bottom)
                .position(x: geo.size.width / 2,
                          y: geo.size.height + (self.height + geo.safeAreaInsets.bottom) / 2 - (self.minHeight + geo.safeAreaInsets.bottom))
                .offset(y: -self.offset)
        }
    }

    private func dragGestureOnChanged(value: DragGesture.Value) {
        self.dragGestureDiffHeight = value.translation.height - self.dragGestureCurrentTranslationHeight
        self.dragGestureCurrentTranslationHeight = value.translation.height

        self.offset =
            max(self.minOffset,
                min(self.maxOffset, self.offset - value.translation.height))
    }

    private func dragGestureOnEnded() {
        if abs(self.dragGestureDiffHeight) < 2 {
            if self.offset > (self.maxOffset + self.minOffset) / 2 {
                self.openModalView()
            } else {
                self.closeModalView()
            }
            return
        }

        if self.dragGestureDiffHeight < 0 {
            self.openModalView()
        } else {
            self.closeModalView()
        }

    }

    private func openModalView() {
        withAnimation(.easeOut(duration: 0.2)) {
            offset = maxOffset
        }
    }

    func closeModalView() {
        withAnimation(.easeOut(duration: 0.2)) {
            offset = minOffset
        }
    }
}
