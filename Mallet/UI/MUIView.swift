//
//  MUIView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/17.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

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
    }
}

struct MUISliderView: View {

    @State private var value = 1.0

    var body: some View {
        Slider(value: $value)
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
                .frame(width: 100)

            MUISliderView()
                .frame(width: 100)

            MUIToggleView()
        }
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
