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
        Group {
            if !self.frameData.lockWidth {
                HStack {
                    Text("Width")
                    Spacer()
                    NumberInputView(value: self.$frameData.frame.width, range: 0...1000)
                }
            }

            if !self.frameData.lockHeight {
                HStack {
                    Text("Height")
                    Spacer()
                    NumberInputView(value: self.$frameData.frame.height, range: 0...1000)
                }
            }
        }
    }
}
