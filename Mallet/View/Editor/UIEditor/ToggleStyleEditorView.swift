//
//  ToggleStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/15.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ToggleStyleEditorView: View {

    @Binding var toggleData: MUIToggleData

    var body: some View {
        Group {
            if toggleData.enabled {
                ListSection(title: "Toggle") {
                    BoolInputCell(value: self.$toggleData.value, title: "Value", symbol: "switch.2")
                }
            }
        }
    }
}

extension ToggleStyleEditorView: Equatable {

    public static func ==(lhs: ToggleStyleEditorView, rhs: ToggleStyleEditorView) -> Bool {
        lhs.toggleData == rhs.toggleData
    }

}
