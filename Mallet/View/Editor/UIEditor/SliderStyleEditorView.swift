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
                    NumberInputCell(value:
                                    Binding(
                                        get: { CGFloat(sliderData.value) },
                                        set: { self.sliderData.value = Float($0) }
                                    )
                        , range: -CGFloat.infinity...CGFloat.infinity, title: "Value", step: 0.1, maxFractionalDigits: 5)

                    NumberInputCell(value:
                                    Binding(
                                        get: { CGFloat(sliderData.maxValue) },
                                        set: { self.sliderData.maxValue = Float($0) }
                                    )
                        , range: -CGFloat.infinity...CGFloat.infinity, title: "Maximum Value", step: 0.1, maxFractionalDigits: 5)

                    NumberInputCell(value:
                                    Binding(
                                        get: { CGFloat(sliderData.minValue) },
                                        set: { self.sliderData.minValue = Float($0) }
                                    )
                        , range: -CGFloat.infinity...CGFloat.infinity, title: "Minimum Value", step: 0.1, maxFractionalDigits: 5)

                    BoolInputCell(value:
                                  Binding(
                                      get: { sliderData.step != nil },
                                      set: { self.sliderData.step = $0 ? 1 : nil }
                                  ), title: "Set Step")

                    if sliderData.step != nil {
                        NumberInputCell(value:
                                        Binding(
                                            get: { CGFloat(sliderData.step ?? 0) },
                                            set: { self.sliderData.step = Float($0) }
                                        )
                            , range: 0.01...CGFloat.infinity, title: "Step", step: 0.1, maxFractionalDigits: 3)
                    }
                }
            }
        }
    }

}

extension SliderStyleEditorView: Equatable {

    static func ==(lhs: SliderStyleEditorView, rhs: SliderStyleEditorView) -> Bool {
        lhs.sliderData == rhs.sliderData
    }

}
