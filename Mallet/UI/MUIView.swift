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
                .frame(width: uiData.frameData.frame.width,
                       height: uiData.frameData.frame.height,
                       alignment: uiData.textData.alignment.toAlignment)
                .foregroundColor(uiData.textData.color.toColor)
                .font(.system(size: uiData.textData.size))
                .multilineTextAlignment(uiData.textData.alignment.toTextAlignment)
        }
    }
}

struct MUIInput: View {

    @Binding var uiData: MUI

    @State var text = "Input"

    var body: some View {
        TextField("", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
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
