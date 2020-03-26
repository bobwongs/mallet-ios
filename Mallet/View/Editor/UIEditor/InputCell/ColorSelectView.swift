//
//  ColorSelectView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ColorSelectView: View {

    @Binding var color: MUIColor

    @State var str = ""

    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .foregroundColor(color.toColor)
                    .frame(width: 50, height: 30)
                    .cornerRadius(5)

                Spacer()

                Text("#")
                TextField("", text: $str, onEditingChanged: { text in

                }, onCommit: {

                })

            }
        }
    }
}
