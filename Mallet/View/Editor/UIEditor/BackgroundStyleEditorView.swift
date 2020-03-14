//
//  BackgroundStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct BackgroundStyleEditorView: View {

    @Binding var backgroundData: MUIBackGround

    var body: some View {
        Group {
            if backgroundData.enabled {
                HStack {
                    Text("Background Color")
                    Spacer()
                    Rectangle()
                        .background(backgroundData.color.toColor)
                        .frame(width: 30)
                        .cornerRadius(5)
                }

                HStack {
                    Text("Corner Radius")
                    Stepper(value: $backgroundData.cornerRadius, in: 0...10000, label: {
                        TextField("", value: self.$backgroundData.cornerRadius, formatter: FractionalNumberFormatter(0...10000, minimumFractionDigits: 0, maximumFractionDigits: 1))
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                    })
                }
            }
        }
    }
}
