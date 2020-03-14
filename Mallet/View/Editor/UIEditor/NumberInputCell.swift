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

    private let title: String

    private let placeholder: String

    init(value: Binding<CGFloat>, range: ClosedRange<CGFloat>, title: String, placeholder: String = "") {
        self._value = value
        self.range = range
        self.title = title
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Text(title)
            Stepper(value: $value, in: range) {
                TextField(self.placeholder, value: self.$value, formatter: FractionalNumberFormatter(self.range, minimumFractionDigits: 0, maximumFractionDigits: 1))
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

}
