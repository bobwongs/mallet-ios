//
//  UIStyleEditorSectionView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/14.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UIStyleEditorSectionView<Content: View>: View {

    let content: () -> Content

    let title: String

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        Section(header:
                Text(title)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
        ) {
            content()
        }
    }
}
