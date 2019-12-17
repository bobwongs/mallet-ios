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

    @Binding var frame: CGRect

    let frameFactors: FrameFactors

    private let dotColor = Color.blue

    var body: some View {
        Circle()
            .foregroundColor(self.dotColor)
            .frame(width: 8, height: 8)
            .gesture(DragGesture()
                    .onChanged { value in
                        self.frame.origin.x += self.frameFactors.x.rawValue * value.translation.width
                        self.frame.origin.y += self.frameFactors.y.rawValue * value.translation.height
                        self.frame.size.width += self.frameFactors.width.rawValue * value.translation.width
                        self.frame.size.height += self.frameFactors.height.rawValue * value.translation.height
                }
            )
    }
}

struct MEditorFrameView: View {

    @Binding var frame: CGRect

    private let dotColor = Color.blue

    private let borderWidth: CGFloat = 1

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .overlay(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(.clear)
                        .border(Color.gray, width: self.borderWidth)
                        .frame(width: geo.size.width + self.borderWidth, height: geo.size.height + self.borderWidth)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .gesture(DragGesture()
                                .onChanged { value in
                                    self.frame.origin.x += value.translation.width
                                    self.frame.origin.y += value.translation.height
                            }
                        )

                    ZStack {
                        Group {
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .positive, width: .negative, height: .negative))
                                .position(x: 0, y: 0)
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .positive, width: .positive, height: .negative))
                                .position(x: geo.size.width, y: 0)
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .positive))
                                .position(x: geo.size.width, y: geo.size.height)
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .positive))
                                .position(x: 0, y: geo.size.height)
                        }

                        Group {
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .positive, width: .zero, height: .negative))
                                .position(x: geo.size.width / 2, y: 0)
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .positive, height: .zero))
                                .position(x: geo.size.width, y: geo.size.height / 2)
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .zero, y: .zero, width: .zero, height: .positive))
                                .position(x: geo.size.width / 2, y: geo.size.height)
                            MEditorFrameDot(frame: self.$frame, frameFactors: FrameFactors(x: .positive, y: .zero, width: .negative, height: .zero))
                                .position(x: 0, y: geo.size.height / 2)
                        }
                    }
                }
            )
    }
}

fileprivate struct Preview: View {

    @State var frame = CGRect(x: 100, y: 100, width: 100, height: 50)

    var body: some View {
        ZStack {
            MEditorFrameView(frame: $frame)
                .frame(width: frame.width, height: frame.height)
                .position(x: frame.midX, y: frame.midY)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MEditorFrameView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
