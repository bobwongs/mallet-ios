//
//  MEditorFrameView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

fileprivate enum FactorValue: Float {
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

fileprivate struct MEditorFrameDot: View {

    @Binding var frame: MRect

    let frameFactors: FrameFactors

    private let dotColor = Color.blue

    private let minWidth: Float = 10

    private let minHeight: Float = 10

    var body: some View {
        Circle()
            .foregroundColor(self.dotColor)
            .frame(width: 12, height: 12)
            .overlay(
                Circle()
                    .foregroundColor(Color.white.opacity(0.001))
                    .frame(width: 25, height: 25)
                    .gesture(DragGesture()
                            .onChanged { value in
                                self.frame.x += min(self.frameFactors.x.rawValue * Float(value.translation.width), self.frame.width - self.minWidth)
                                self.frame.y += min(self.frameFactors.y.rawValue * Float(value.translation.height), self.frame.height - self.minHeight)
                                self.frame.width = max(self.frame.width + self.frameFactors.width.rawValue * Float(value.translation.width), self.minWidth)
                                self.frame.height = max(self.frame.height + self.frameFactors.height.rawValue * Float(value.translation.height), self.minHeight)
                        }
                    )
            )
    }
}

struct MEditorFrameView<Content>: View where Content: View {

    let content: () -> Content

    @Binding var uiData: MUI

    @Binding var frame: MRect

    @Binding var selectedUIID: Int?

    private let dotColor = Color.blue

    private let borderWidth: CGFloat = 2

    init(uiData: Binding<MUI>, selectedUIID: Binding<Int?>, @ViewBuilder content: @escaping () -> Content) {
        self._uiData = uiData

        self._frame = uiData.frame

        self._selectedUIID = selectedUIID

        self.content = content
    }

    var body: some View {
        content()
            .frame(width: CGFloat(frame.width), height: CGFloat(frame.height))
            .background(Color.black.opacity(0.03))
            .position(x: CGFloat(frame.midX), y: CGFloat(frame.midY))
            .overlay(
                Group {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.white.opacity(0.001))
                            .gesture(DragGesture()
                                    .onChanged { value in
                                        self.frame.x += Float(value.translation.width)
                                        self.frame.y += Float(value.translation.height)
                                        self.setSelectedUIID()
                                })
                            .frame(width: CGFloat(self.frame.width) + self.borderWidth, height: CGFloat(self.frame.height) + self.borderWidth)
                            .position(x: CGFloat(self.frame.midX), y: CGFloat(self.frame.midY))

                        Group {
                            if self.uiData.uiID == self.selectedUIID {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .border(Color.gray, width: self.borderWidth)
                                    .frame(width: CGFloat(self.frame.width) + self.borderWidth, height: CGFloat(self.frame.height) + self.borderWidth)
                                    .position(x: CGFloat(self.frame.midX), y: CGFloat(self.frame.midY))


                                Group {
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .positive, width: .negative, height: .negative))
                                        .position(x: CGFloat(self.frame.x), y: CGFloat(self.frame.y))
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .positive, width: .positive, height: .negative))
                                        .position(x: CGFloat(self.frame.x) + CGFloat(self.frame.width), y: CGFloat(self.frame.y))
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .positive))
                                        .position(x: CGFloat(self.frame.x) + CGFloat(self.frame.width), y: CGFloat(self.frame.y) + CGFloat(self.frame.height))
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .positive))
                                        .position(x: CGFloat(self.frame.x), y: CGFloat(self.frame.y) + CGFloat(self.frame.height))
                                }

                                Group {
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .positive, width: .zero, height: .negative))
                                        .position(x: CGFloat(self.frame.x) + CGFloat(self.frame.width) / 2, y: CGFloat(self.frame.y))
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .zero))
                                        .position(x: CGFloat(self.frame.x) + CGFloat(self.frame.width), y: CGFloat(self.frame.y) + CGFloat(self.frame.height) / 2)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .zero, height: .positive))
                                        .position(x: CGFloat(self.frame.x) + CGFloat(self.frame.width) / 2, y: CGFloat(self.frame.y) + CGFloat(self.frame.height))
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .zero))
                                        .position(x: CGFloat(self.frame.x), y: CGFloat(self.frame.y) + CGFloat(self.frame.height) / 2)
                                }
                            }
                        }
                    }
                }

                    .gesture(TapGesture()
                            .onEnded {
                                self.setSelectedUIID()
                        }
                    )
            )
    }

    private func setSelectedUIID() {
        selectedUIID = uiData.uiID
    }
}

fileprivate struct Preview: View {
    var body: some View {
        ZStack {
            Color.gray
        }
    }
}

struct MEditorFrameView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
