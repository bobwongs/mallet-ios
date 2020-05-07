//
//  ColorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ColorView: View {

    @Binding var color: MUIColor

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(color.color)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }

}
