//
//  ListCell.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/17.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ListCell<Content: View>: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            content()
                .padding(.horizontal, 15)
                .frame(height: 44)
        }
    }
}
