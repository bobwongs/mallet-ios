//
//  MUIView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/17.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIText: View {
    var body: some View {
        Text("Label")
    }
}

struct MUIButton: View {
    var body: some View {
        Button("Button") {
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

    @State private var value = true

    var body: some View {
        Toggle("", isOn: $value)
            .labelsHidden()
    }
}

struct MUISpace: View {
    var body: some View {
        Spacer()
    }
}

struct MUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUIText()

            MUIButton()

            MUIInput()
                .frame(width: 100)

            MUISlider()
                .frame(width: 100)

            MUIToggle()
        }
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
