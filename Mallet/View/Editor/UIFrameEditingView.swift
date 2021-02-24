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

    @Binding var defaultDotSize: CGFloat

    let frameFactors: FrameFactors

    let onEnded: () -> ()

    @State private var selected = false

    private var dotSize: CGFloat {
        selected ? defaultDotSize * 1.5 : defaultDotSize
    }

    private let dotColor = Color.blue

    private let minWidth: CGFloat = 10

    private let minHeight: CGFloat = 10

    var body: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: dotSize, height: dotSize)
            .overlay(
                Circle()
                    .foregroundColor(dotColor)
                    .frame(width: dotSize * 0.8, height: dotSize * 0.8)
                    .shadow(radius: 1)
            )
            .overlay(
                Circle()
                    .foregroundColor(Color.white.opacity(0.001))
                    .frame(width: defaultDotSize * 2, height: defaultDotSize * 2)
                    .gesture(DragGesture(minimumDistance: 0)
                                 .onChanged { value in
                                     withAnimation(.easeIn(duration: 0.05)) {
                                         selected = true
                                     }
                                     self.frame.x += min(frameFactors.x.rawValue * value.translation.width, frame.width - minWidth)
                                     self.frame.y += min(frameFactors.y.rawValue * value.translation.height, frame.height - minHeight)
                                     self.frame.width = max(frame.width + frameFactors.width.rawValue * value.translation.width, minWidth)
                                     self.frame.height = max(frame.height + frameFactors.height.rawValue * value.translation.height, minHeight)
                                 }
                                 .onEnded { _ in
                                     withAnimation(.easeOut(duration: 0.05)) {
                                         selected = false
                                     }
                                     onEnded()
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

    let appViewGeo: GeometryProxy

    @State private var showUISettings = false

    private let dotColor = Color.blue

    private var dotSize: Binding<CGFloat> {
        Binding(
            get: { 10 / appViewScale },
            set: { _ in }
        )
    }

    private var borderWidth: CGFloat {
        1 / appViewScale
    }

    init(uiData: Binding<MUI>, appViewScale: Binding<CGFloat>, appViewGeo: GeometryProxy, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frameData = uiData.frameData

        self._appViewScale = appViewScale

        self.appViewGeo = appViewGeo

        self.content = content
    }

    var body: some View {
        content()
            .hidden()
            .overlay(
                ZStack {
                    Color.clear
                        .padding(borderWidth / 2)
                        .border(Color.blue, width: borderWidth)

                    GeometryReader { geo in
                        dotView(size: geo.size,
                                onEnded: {
                                    print(editorViewModel.findUIPosInGrid(uiGeo: geo, appViewGeo: appViewGeo))
                                })
                    }
                }
            )
            .position(x: frameData.frame.midX, y: frameData.frame.midY)
    }

    private func dotView(size: CGSize, onEnded: @escaping () -> ()) -> some View {
        ZStack {
            if !(frameData.lockHeight || frameData.lockWidth) {
                // LT
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .positive, y: .positive, width: .negative, height: .negative), onEnded: onEnded)
                    .position(x: 0, y: 0)

                // RT
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .zero, y: .positive, width: .positive, height: .negative), onEnded: onEnded)
                    .position(x: size.width, y: 0)

                // RB
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .positive), onEnded: onEnded)
                    .position(x: size.width, y: size.height)

                // LB
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .positive), onEnded: onEnded)
                    .position(x: 0, y: size.height)
            }

            if !frameData.lockHeight {
                // T
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .zero, y: .positive, width: .zero, height: .negative), onEnded: onEnded)
                    .position(x: size.width / 2, y: 0)

                // B
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .zero, height: .positive), onEnded: onEnded)
                    .position(x: size.width / 2, y: size.height)
            }

            if !frameData.lockWidth {
                // R
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .zero), onEnded: onEnded)
                    .position(x: size.width, y: size.height / 2)

                // L
                UIFrameDot(frame: $frameData.frame, defaultDotSize: dotSize, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .zero), onEnded: onEnded)
                    .position(x: 0, y: size.height / 2)
            }
        }
    }
}