//
//  TextInputCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextInputCell: View {

    @Binding private var text: String

    private let title: String

    private let symbol: String?

    private let placeholder: String

    init(text: Binding<String>, title: String, symbol: String? = nil, placeholder: String = "") {
        self._text = text
        self.title = title
        self.symbol = symbol
        self.placeholder = placeholder
    }

    var body: some View {
        ListCell {
            HStack {
                if let symbol = symbol {
                    Image(systemName: symbol)
                }
                Text(title)
                TextField(placeholder, text: self.$text)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}
