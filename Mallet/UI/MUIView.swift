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
            .frame(width: uiData.frameData.frame.width,
                   height: uiData.frameData.frame.height,
                   alignment: uiData.textData.alignment.toAlignment)
            .foregroundColor(uiData.textData.color.color)
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
                .frame(width: uiData.frameData.frame.width,
                       height: uiData.frameData.frame.height,
                       alignment: uiData.textData.alignment.toAlignment)
                .foregroundColor(uiData.textData.color.color)
                .font(.system(size: uiData.textData.size))
                .multilineTextAlignment(uiData.textData.alignment.toTextAlignment)
        }
    }
}

struct MUITextField: View {

    @Binding var uiData: MUI

    var body: some View {
        TextField(uiData.textFieldData.placeholder, text: $uiData.textFieldData.text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(uiData.textFieldData.color.color)
            .font(.system(size: uiData.textFieldData.size))
            .multilineTextAlignment(uiData.textFieldData.alignment.toTextAlignment)
    }
}

struct MUISlider: View {

    @Binding var uiData: MUI

    var body: some View {
        Slider(value: $uiData.sliderData.value, in: uiData.sliderData.minValue...uiData.sliderData.maxValue)
    }
}

struct MUIToggle: View {

    @Binding var uiData: MUI

    var body: some View {
        Toggle("", isOn: $uiData.toggleData.value)
            .labelsHidden()
            .padding(.trailing, 2)
    }
}

struct MUISpace: View {
    var body: some View {
        Spacer()
    }
}
