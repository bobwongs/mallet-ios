//
//  DefaultPreview.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/19.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct DefaultPreview<Content>: View where Content: View {
    
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        Group {
            NavigationView {
                content()
            }
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            NavigationView {
                content()
            }
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            NavigationView {
                content()
            }
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))

            NavigationView {
                content()
            }
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
        }
            .navigationViewStyle(StackNavigationViewStyle()) }
}
