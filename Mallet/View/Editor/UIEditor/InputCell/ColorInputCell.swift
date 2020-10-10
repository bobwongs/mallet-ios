//
//  ColorInputView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ColorInputCell: View {

    @Binding private var showingSubEditor: Bool

    @Binding private var color: MUIColor

    private let title: String

    private let symbol: String?

    init(color: Binding<MUIColor>, title: String, symbol: String? = nil, showingSubEditor: Binding<Bool>) {
        self._color = color
        self.title = title
        self.symbol = symbol
        self._showingSubEditor = showingSubEditor
    }

    var body: some View {
        NavigationLink(destination:
                       ColorSelectView(color: $color)
                           .onAppear {
                               self.showingSubEditor = true
                           }
                           .onDisappear {
                               self.showingSubEditor = false
                           }
        ) {
            ListCell {
                HStack {
                    Group {
                        if let symbol = symbol {
                            Image(systemName: symbol)
                        }
                        Text(title)
                    }
                        .foregroundColor(.primary)
                    Spacer()
                    ColorView(color: self.$color)
                        .frame(width: 50, height: 30)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }
            }
        }
    }
}
