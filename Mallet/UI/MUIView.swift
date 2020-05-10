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
        YASlider(value: $uiData.sliderData.value, in: uiData.sliderData.minValue...uiData.sliderData.maxValue,
                 onEditingStarted: {
                     self.invokeAction?(self.uiData.sliderData.onStarted.xyloFuncName(uiID: self.uiData.uiID))
                 },
                 onEditingChanged: {
                     self.invokeAction?(self.uiData.sliderData.onChanged.xyloFuncName(uiID: self.uiData.uiID))
                 },
                 onEditingEnded: {
                     self.invokeAction?(self.uiData.sliderData.onEnded.xyloFuncName(uiID: self.uiData.uiID))
                 }
        )
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
        YAToggle(isOn: $uiData.toggleData.value, onChanged: {
            self.invokeAction?(self.uiData.toggleData.onChanged.xyloFuncName(uiID: self.uiData.uiID))
        })
            .padding(.trailing, 2)
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