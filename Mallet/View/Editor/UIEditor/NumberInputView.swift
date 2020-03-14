//
//  NumberInputView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct NumberInputView: View {

    @Binding private var value: CGFloat

    private let range: ClosedRange<CGFloat>

    init(value: Binding<CGFloat>, range: ClosedRange<CGFloat>) {
        self._value = value
        self.range = range
    }

    var body: some View {
        Stepper(value: $value, in: range) {
            TextField("", value: self.$value, formatter: FractionalNumberFormatter(self.range, minimumFractionDigits: 0, maximumFractionDigits: 1))
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.trailing)
        }
    }

}
