//
//  BackgroundStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct BackgroundStyleEditorView: View {

    @EnvironmentObject var uiStyleEditorViewModel: UIStyleEditorViewModel

    @Binding var backgroundData: MUIBackgroundData

    var body: some View {
        Group {
            if backgroundData.enabled {
                ColorInputCell(color: $backgroundData.color, title: "Background Color")
                    .environmentObject(uiStyleEditorViewModel)

                NumberInputCell(value: $backgroundData.cornerRadius, range: 0...10000, title: "Corner Radius")
            }
        }
    }
}
