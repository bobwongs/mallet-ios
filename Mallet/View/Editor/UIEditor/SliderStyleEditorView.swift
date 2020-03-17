//
//  SliderStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/15.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct SliderStyleEditorView: View {

    @Binding var sliderData: MUISliderData

    var body: some View {
        Group {
            if sliderData.enabled {
                ListSection(title: "Slider") {
                    NumberInputCell(value: self.$sliderData.value, range: -CGFloat.infinity...CGFloat.infinity, title: "Value", step: 0.1, maxFractionalDigits: 5)

                    NumberInputCell(value: self.$sliderData.maxValue, range: -CGFloat.infinity...CGFloat.infinity, title: "Maximum Value", step: 0.1, maxFractionalDigits: 5)

                    NumberInputCell(value: self.$sliderData.minValue, range: -CGFloat.infinity...CGFloat.infinity, title: "Minimum Value", step: 0.1, maxFractionalDigits: 5)
                }
            }
        }
    }
}
