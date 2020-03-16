//
//  UIFrameEditingView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI


fileprivate enum FactorValue: CGFloat {
    case positive = 1
    case zero = 0
    case negative = -1
}

fileprivate struct FrameFactors {
    let x: FactorValue
    let y: FactorValue
    let width: FactorValue
    let height: FactorValue
}

fileprivate struct UIFrameDot: View {

    @Binding var frame: MUIRect

    @Binding var size: CGFloat

    let frameFactors: FrameFactors

    let onChanged: () -> Void

    private let dotColor = Color.blue

    private let minWidth: CGFloat = 10

    private let minHeight: CGFloat = 10

    var body: some View {
        Circle()
            .foregroundColor(self.dotColor)
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .foregroundColor(Color.white.opacity(0.001))
                    .frame(width: size * 2, height: size * 2)
                    .gesture(DragGesture()
                                 .onChanged { value in
                                     self.frame.x += min(self.frameFactors.x.rawValue * value.translation.width, self.frame.width - self.minWidth)
                                     self.frame.y += min(self.frameFactors.y.rawValue * value.translation.height, self.frame.height - self.minHeight)
                                     self.frame.width = max(self.frame.width + self.frameFactors.width.rawValue * value.translation.width, self.minWidth)
                                     self.frame.height = max(self.frame.height + self.frameFactors.height.rawValue * value.translation.height, self.minHeight)
                                     self.onChanged()
                                 }
                    )
            )
    }
}

struct UIFrameEditingView<Content: View>: View {

    let content: () -> Content

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var uiData: MUI

    @Binding var frameData: MUIFrameData

    @Binding var appViewScale: CGFloat

    @State private var showUISettings = false

    private let dotColor = Color.blue

    private var dotSize: Binding<CGFloat> {
        Binding(
            get: { 8 / self.appViewScale },
            set: { _ in }
        )
    }

    private var borderWidth: CGFloat {
        1 / self.appViewScale
    }

    init(uiData: Binding<MUI>, appViewScale: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frameData = uiData.frameData

        self._appViewScale = appViewScale

        self.content = content
    }

    var body: some View {
        self.content()
            .hidden()
            .overlay(
                ZStack {
                    Color.clear
                        .padding(self.borderWidth / 2)
                        .border(Color.blue, width: self.borderWidth)

                    GeometryReader { geo in
                        self.dotView(onChanged: { self.updateFrame(geo) })
                    }
                }
            )
            .position(x: self.frameData.frame.midX, y: self.frameData.frame.midY)
    }

    private func dotView(onChanged: @escaping () -> Void) -> some View {
        ZStack {
            if !(frameData.lockHeight || frameData.lockWidth) {
                // LT
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .positive, y: .positive, width: .negative, height: .negative), onChanged: onChanged)
                    .position(x: 0, y: 0)

                // RT
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .positive, width: .positive, height: .negative), onChanged: onChanged)
                    .position(x: frameData.frame.width, y: 0)

                // RB
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .positive), onChanged: onChanged)
                    .position(x: frameData.frame.width, y: frameData.frame.height)

                // LB
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .positive), onChanged: onChanged)
                    .position(x: 0, y: frameData.frame.height)
            }

            if !frameData.lockHeight {
                // T
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .positive, width: .zero, height: .negative), onChanged: onChanged)
                    .position(x: frameData.frame.width / 2, y: 0)

                // B
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .zero, height: .positive), onChanged: onChanged)
                    .position(x: frameData.frame.width / 2, y: frameData.frame.height)
            }

            if !frameData.lockWidth {
                // R
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .zero), onChanged: onChanged)
                    .position(x: frameData.frame.width, y: frameData.frame.height / 2)

                // L
                UIFrameDot(frame: $frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .zero), onChanged: onChanged)
                    .position(x: 0, y: frameData.frame.height / 2)
            }
        }
    }

    private func updateFrame(_ geo: GeometryProxy) {
        editorViewModel.selectUI(id: uiData.uiID, frame: geo.frame(in: .global))
    }
}