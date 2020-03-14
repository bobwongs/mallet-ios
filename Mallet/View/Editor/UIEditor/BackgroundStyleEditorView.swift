//
//  BackgroundStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct BackgroundStyleEditorView: View {

    @Binding var backgroundData: MUIBackgroundData

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
                    NumberInputView(value: $backgroundData.cornerRadius, range: 0...10000)
                }
            }
        }
    }
}
