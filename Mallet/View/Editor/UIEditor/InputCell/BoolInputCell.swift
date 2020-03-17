//
//  BoolInputCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/15.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct BoolInputCell: View {

    @Binding private var value: Bool

    private let title: String

    init(value: Binding<Bool>, title: String) {
        self._value = value

        self.title = title
    }

    var body: some View {
        ListCell {
            HStack {
                Text(self.title)
                Spacer()
                Toggle("", isOn: self.$value)
                    .labelsHidden()
            }
        }
    }
}
