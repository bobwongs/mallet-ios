//
//  MEditorUIView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MEditorText: View {
    var body: some View {
        MUIText()
            .overlay(Color.white.opacity(0))
    }
}

struct MEditorButton: View {
    var body: some View {
        MUIButton()
            .overlay(Color.white.opacity(0))
    }
}

struct MEditorInput: View {
    var body: some View {
        MUIInput()
            .overlay(Color.white.opacity(0))
    }
}

struct MEditorSlider: View {
    var body: some View {
        MUISlider()
            .overlay(Color.white.opacity(0))
    }
}

struct MEditorToggle: View {
    var body: some View {
        MUIToggle()
            .overlay(Color.white.opacity(0))
    }
}
