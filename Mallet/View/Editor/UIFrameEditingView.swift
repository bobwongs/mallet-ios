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
                                 }
                    )
            )
    }
}

struct UIFrameEditingView: View {

    @Binding var uiData: MUI

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

    var body: some View {
        Rectangle()
            .frame(width: uiData.frameData.frame.width, height: uiData.frameData.frame.height)
            .foregroundColor(.clear)
            .position(x: uiData.frameData.frame.midX, y: uiData.frameData.frame.midY)
            .overlay(
                Group {
                    ZStack {
                        Group {
                            Group {
                                if !(uiData.frameData.lockHeight || uiData.frameData.lockWidth) {
                                    // LT
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .positive, y: .positive, width: .negative, height: .negative))
                                        .position(x: uiData.frameData.frame.x, y: uiData.frameData.frame.y)

                                    // RT
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .positive, width: .positive, height: .negative))
                                        .position(x: uiData.frameData.frame.x + uiData.frameData.frame.width, y: uiData.frameData.frame.y)

                                    // RB
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .positive))
                                        .position(x: uiData.frameData.frame.x + uiData.frameData.frame.width, y: uiData.frameData.frame.y + uiData.frameData.frame.height)

                                    // LB
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .positive))
                                        .position(x: uiData.frameData.frame.x, y: uiData.frameData.frame.y + uiData.frameData.frame.height)
                                }
                            }

                            Group {
                                if !uiData.frameData.lockHeight {
                                    // T
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .positive, width: .zero, height: .negative))
                                        .position(x: uiData.frameData.frame.x + uiData.frameData.frame.width / 2, y: uiData.frameData.frame.y)

                                    // B
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .zero, height: .positive))
                                        .position(x: uiData.frameData.frame.x + uiData.frameData.frame.width / 2, y: uiData.frameData.frame.y + uiData.frameData.frame.height)
                                }

                                if !uiData.frameData.lockWidth {
                                    // R
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .zero))
                                        .position(x: uiData.frameData.frame.x + uiData.frameData.frame.width, y: uiData.frameData.frame.y + uiData.frameData.frame.height / 2)

                                    // L
                                    UIFrameDot(frame: $uiData.frameData.frame, size: dotSize, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .zero))
                                        .position(x: uiData.frameData.frame.x, y: uiData.frameData.frame.y + uiData.frameData.frame.height / 2)
                                }
                            }
                        }
                    }
                }
            )
    }
}