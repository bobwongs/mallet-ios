//
//  EditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
                .navigationBarTitle("App Title", displayMode: .inline)
                .navigationBarItems(trailing:
                        HStack {
                            Button(action: {
                                print("Settings")
                            }) {
                                Image(systemName: "square.and.arrow.up")
                            }
                            Button(action: {
                                print("Run")
                            }) {
                                Image(systemName: "play.fill")
                            }
                    }
                )
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            EditorView()
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            EditorView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))

            EditorView()
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
        }
    }
}
