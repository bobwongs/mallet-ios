//
//  ColorInputView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ColorInputCell: View {

    @Binding private var color: MUIColor

    private let title: String

    init(color: Binding<MUIColor>, title: String) {
        self._color = color

        self.title = title
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Rectangle()
                .foregroundColor(color.toColor)
                //.background(color.toColor)
                .frame(width: 30)
                .cornerRadius(5)
        }
    }
}
