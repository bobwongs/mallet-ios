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
        NavigationLink(destination: ColorSelectView(color: $color)) {
            ListCell {
                HStack {
                    Text(self.title)
                        .foregroundColor(.primary)
                    Spacer()
                    Rectangle()
                        .foregroundColor(self.color.color)
                        .frame(width: 50, height: 30)
                        .cornerRadius(5)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }
            }
        }
    }
}
