//
//  ButtonStyleEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/08.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ButtonStyleEditorView: View {

    @Binding var buttonData: MUIButtonData

    var body: some View {
        Group {
            if buttonData.enabled {
                EmptyView()
            }
        }
    }

}
