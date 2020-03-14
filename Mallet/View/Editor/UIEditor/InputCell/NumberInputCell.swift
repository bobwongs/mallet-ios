//
//  NumberInputCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct NumberInputCell: View {

    @Binding private var value: CGFloat

    private let range: ClosedRange<CGFloat>

    private let step: CGFloat

    private let minFractionalDigits: Int

    private let maxFractionalDigits: Int

    private let title: String

    private let placeholder: String

    init(value: Binding<CGFloat>,
         range: ClosedRange<CGFloat>,
         title: String,
         placeholder: String = "",
         step: CGFloat = 1,
         minFractionalDigits: Int = 0,
         maxFractionalDigits: Int = 1) {
        self._value = value
        self.range = range
        self.step = step
        self.minFractionalDigits = minFractionalDigits
        self.maxFractionalDigits = maxFractionalDigits
        self.title = title
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Text(title)
            Stepper(value: $value, in: range, step: step) {
                TextField(self.placeholder,
                          value: self.$value,
                          formatter: FractionalNumberFormatter(self.range, minimumFractionDigits: self.minFractionalDigits, maximumFractionDigits: self.maxFractionalDigits))
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

}