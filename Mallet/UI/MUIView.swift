//
//  MUIView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/17.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIText: View {

    @Binding var uiData: MUI

    var body: some View {
        Text(uiData.textData.text)
            .foregroundColor(uiData.textData.color.toColor)
            .font(.system(size: uiData.textData.size))
            .multilineTextAlignment(uiData.textData.alignment.toTextAlignment)
    }
}

struct MUIButton: View {

    @Binding var uiData: MUI

    var body: some View {
        Button(action: {

        }) {
            Text(uiData.textData.text)
                .foregroundColor(uiData.textData.color.toColor)
                .font(.system(size: uiData.textData.size))
                .multilineTextAlignment(uiData.textData.alignment.toTextAlignment)
        }
    }
}

struct MUIInput: View {

    @State var text = "Input"

    var body: some View {
        TextField("", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct MUISlider: View {

    @State private var value = 1.0

    var body: some View {
        Slider(value: $value)
    }
}

struct MUIToggle: View {

    @Binding var uiData: MUI

    @State private var value = true

    var body: some View {
        Toggle("", isOn: self.$value)
            .labelsHidden()
            .padding(.trailing, 2)
    }
}

struct MUISpace: View {
    var body: some View {
        Spacer()
    }
}
