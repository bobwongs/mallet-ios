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

struct MUIButton: View, MUIInteractive {

    @Binding private var uiData: MUI

    var invokeAction: ((String) -> ())? = nil

    init(uiData: Binding<MUI>, invokeAction: ((String) -> ())? = nil) {
        self._uiData = uiData
        self.invokeAction = invokeAction
    }

    var body: some View {
        Button(action: {
            self.invokeAction?(self.uiData.buttonData.onTapped.xyloFuncName(uiID: self.uiData.uiID))
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

struct MUITextField: View, MUIInteractive {

    @Binding var uiData: MUI

    var invokeAction: ((String) -> ())? = nil

    init(uiData: Binding<MUI>, invokeAction: ((String) -> ())? = nil) {
        self._uiData = uiData
        self.invokeAction = invokeAction
    }

    var body: some View {
        TextField(uiData.textFieldData.placeholder, text: $uiData.textFieldData.text, onCommit: {
            self.invokeAction?(self.uiData.textFieldData.onCommit.xyloFuncName(uiID: self.uiData.uiID))
        })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(uiData.textFieldData.color.color)
            .font(.system(size: uiData.textFieldData.size))
            .multilineTextAlignment(uiData.textFieldData.alignment.toTextAlignment)
    }
}

struct MUISlider: View, MUIInteractive {

    @Binding var uiData: MUI

    var invokeAction: ((String) -> ())? = nil

    init(uiData: Binding<MUI>, invokeAction: ((String) -> ())? = nil) {
        self._uiData = uiData
        self.invokeAction = invokeAction
    }

    var body: some View {
        Group {
            if let step = uiData.sliderData.step {
                Slider(value: $uiData.sliderData.value, in: uiData.sliderData.minValue...uiData.sliderData.maxValue, step: step) { _ in
                    invokeAction?(uiData.sliderData.onEnded.xyloFuncName(uiID: uiData.uiID))
                }
            } else {
                Slider(value: $uiData.sliderData.value, in: uiData.sliderData.minValue...uiData.sliderData.maxValue) { _ in
                    invokeAction?(uiData.sliderData.onEnded.xyloFuncName(uiID: uiData.uiID))
                }
            }
        }
            .onChange(of: uiData.sliderData.value) { _ in
                invokeAction?(uiData.sliderData.onChanged.xyloFuncName(uiID: uiData.uiID))
            }
    }
}

struct MUIToggle: View, MUIInteractive {

    @Binding var uiData: MUI

    var invokeAction: ((String) -> ())? = nil

    init(uiData: Binding<MUI>, invokeAction: ((String) -> ())? = nil) {
        self._uiData = uiData
        self.invokeAction = invokeAction
    }

    var body: some View {
        Toggle("", isOn: $uiData.toggleData.value)
            .labelsHidden()
            .padding(.trailing, 2)
            .onChange(of: uiData.toggleData.value) { value in
                invokeAction?(uiData.toggleData.onChanged.xyloFuncName(uiID: uiData.uiID))
            }
    }
}

struct MUISpace: View {
    var body: some View {
        Spacer()
    }
}

protocol MUIInteractive {

    var invokeAction: ((String) -> ())? { get set }

}