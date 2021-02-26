//
//  FrameStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct FrameStyleEditorView: View {

    @Binding var frameData: MUIFrameData

    var body: some View {
        VStack(spacing: 0) {
            Text("//TODO:")
            /*
            if !frameData.lockWidth {
                NumberInputCell(value: self.$frameData.frame.width, range: 0...1000, title: "Width", symbol: "arrow.left.and.right.square")
            }

            if !frameData.lockHeight {
                NumberInputCell(value: self.$frameData.frame.height, range: 0...1000, title: "Height", symbol: "arrow.up.and.down.square")
            }
            */
        }
    }
}

extension FrameStyleEditorView: Equatable {

    static func ==(lhs: FrameStyleEditorView, rhs: FrameStyleEditorView) -> Bool {
        lhs.frameData == rhs.frameData
    }

}
