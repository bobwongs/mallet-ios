//
//  ListSection.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/17.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ListSection<Content: View>: View {

    let content: () -> Content

    let title: String

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.title = title
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
            }
                .padding(.horizontal, 15)
                .frame(height: 35)
                .background(Blur(style: .systemMaterial).background(Color.gray))
            content()
        }
    }
}