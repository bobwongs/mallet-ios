//
//  TextStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextStyleEditorView: View {

    @Binding var textData: MUITextData

    var body: some View {
        Group {
            if textData.enabled {
                UIStyleEditorSectionView(title: "Text") {
                    HStack {
                        Text("Text:")
                        TextField("Text", text: self.$textData.text)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Size:")
                        Stepper(value: self.$textData.size, in: 0.1...100, label: {
                            TextField("", value: self.$textData.size, formatter: FractionalNumberFormatter(0.1...100, minimumFractionDigits: 0, maximumFractionDigits: 1))
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                        })
                    }
                }
            }
        }
    }
}
