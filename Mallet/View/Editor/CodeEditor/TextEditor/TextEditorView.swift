//
//  TextEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct TextEditorView: View {

    @Binding var uiData: MUI

    @State var text = ""

    var body: some View {
        TextEditorTextView(text: $text)
    }

}
