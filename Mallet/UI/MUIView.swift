//
//  MUIView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/17.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MUITextView: View {
    var body: some View {
        Text("Label")
    }
}

struct MUIButtonView: View {
    var body: some View {
        Button("Button") {
        }
    }
}

struct MUIInputView: View {

    @State var text = "Input"

    var body: some View {
        TextField("", text: $text)
            .frame(width: 100)
    }
}

struct MUISliderView: View {

    @State private var value = 1.0

    var body: some View {
        Slider(value: $value)
            .frame(width: 100)
    }
}

struct MUIToggleView: View {

    @State private var value = true

    var body: some View {
        Toggle ("", isOn: $value)
            .labelsHidden()
    }
}

struct MUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUITextView()

            MUIButtonView()

            MUIInputView()

            MUISliderView()

            MUIToggleView()
        }
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
