//
//  MEditorFrameView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
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

fileprivate struct MEditorFrameDot: View {

    @Binding var frame: MRect

    let frameFactors: FrameFactors

    private let dotColor = Color.blue

    private let minWidth: CGFloat = 10

    private let minHeight: CGFloat = 10

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
                                     self.frame.x += min(self.frameFactors.x.rawValue * value.translation.width, self.frame.width - self.minWidth)
                                     self.frame.y += min(self.frameFactors.y.rawValue * value.translation.height, self.frame.height - self.minHeight)
                                     self.frame.width = max(self.frame.width + self.frameFactors.width.rawValue * value.translation.width, self.minWidth)
                                     self.frame.height = max(self.frame.height + self.frameFactors.height.rawValue * value.translation.height, self.minHeight)
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
            .frame(width: frame.width, height: frame.height)
            .background(Color.black.opacity(0.03))
            .position(x: frame.midX, y: frame.midY)
            .overlay(
                Group {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.white.opacity(0.001))
                            .gesture(DragGesture()
                                         .onChanged { value in
                                             self.frame.x += value.translation.width
                                             self.frame.y += value.translation.height
                                             self.setSelectedUIID()
                                         })
                            .frame(width: self.frame.width + self.borderWidth, height: self.frame.height + self.borderWidth)
                            .position(x: self.frame.midX, y: self.frame.midY)

                        Group {
                            if self.uiData.uiID == self.selectedUIID {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .border(Color.gray, width: self.borderWidth)
                                    .frame(width: self.frame.width + self.borderWidth, height: self.frame.height + self.borderWidth)
                                    .position(x: self.frame.midX, y: self.frame.midY)


                                Group {
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .positive, width: .negative, height: .negative))
                                        .position(x: self.frame.x, y: self.frame.y)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .positive, width: .positive, height: .negative))
                                        .position(x: self.frame.x + self.frame.width, y: self.frame.y)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .positive))
                                        .position(x: self.frame.x + self.frame.width, y: self.frame.y + self.frame.height)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .positive))
                                        .position(x: self.frame.x, y: self.frame.y + self.frame.height)
                                }

                                Group {
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .positive, width: .zero, height: .negative))
                                        .position(x: self.frame.x + self.frame.width / 2, y: self.frame.y)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .zero))
                                        .position(x: self.frame.x + self.frame.width, y: self.frame.y + self.frame.height / 2)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .zero, height: .positive))
                                        .position(x: self.frame.x + self.frame.width / 2, y: self.frame.y + self.frame.height)
                                    MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .zero))
                                        .position(x: self.frame.x, y: self.frame.y + self.frame.height / 2)
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
