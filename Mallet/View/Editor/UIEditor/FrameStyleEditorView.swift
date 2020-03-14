//
//  FrameStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct FrameStyleEditorView: View {

    @Binding var frameData: MUIFrame

    var body: some View {
        Group {
            if !self.frameData.lockWidth {
                HStack {
                    Text("Width")
                    Spacer()
                    Stepper(value: self.$frameData.frame.width, in: 0...1000) {
                        TextField("", value: self.$frameData.frame.width, formatter: FractionalNumberFormatter(0...1000, minimumFractionDigits: 0, maximumFractionDigits: 1))
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }

            if !self.frameData.lockHeight {
                HStack {
                    Text("Height")
                    Spacer()
                    Stepper(value: self.$frameData.frame.height, in: 0...1000) {
                        TextField("", value: self.$frameData.frame.height, formatter: FractionalNumberFormatter(0...1000, minimumFractionDigits: 0, maximumFractionDigits: 1))
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
}
