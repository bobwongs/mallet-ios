//
//  MEditorFrameView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/13.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

fileprivate struct MEditorFrameDot: View {

    @Binding var frame: CGRect

    private let dotColor = Color.blue

    var body: some View {
        Circle()
            .foregroundColor(self.dotColor)
            .frame(width: 8, height: 8)
    }
}

struct MEditorFrameView: View {

    @Binding var frame: CGRect

    private let dotColor = Color.blue

    private let borderWidth: CGFloat = 1

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .padding()
            .overlay(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(.clear)
                        .border(Color.gray, width: self.borderWidth)
                        .frame(width: geo.size.width + self.borderWidth, height: geo.size.height + self.borderWidth)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)

                    ZStack {
                        Group {
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: 0, y: 0)
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: geo.size.width, y: 0)
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: geo.size.width, y: geo.size.height)
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: 0, y: geo.size.height)
                        }

                        Group {
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: geo.size.width / 2, y: 0)
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: geo.size.width, y: geo.size.height / 2)
                            MEditorFrameDot(frame: self.$frame)
                                .position(x: geo.size.width / 2, y: geo.size.height)
                            MEditorFrameDot(frame: self.$frame)
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
