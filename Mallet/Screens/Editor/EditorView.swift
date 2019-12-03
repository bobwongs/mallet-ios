//
//  EditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorView: View {

    @State var showingAppSettingsView = false

    @State var initialDragAmount: CGFloat = 250

    @State var dragAmount: CGFloat = 250

    private let uiTableModalHeight: CGFloat = 300

    private let uiTableModalMaxVisibleHeight: CGFloat = 250

    private let uiTableModalMinVisibleHeight: CGFloat = 50

    var body: some View {
        ZStack (alignment: .bottom) {
            EditorAppView()

            EditorModalView()
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("App Title", displayMode: .inline)
            .navigationBarItems(trailing:
                    HStack {
                        Button(action: {
                            self.showingAppSettingsView = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                            .sheet(isPresented: self.$showingAppSettingsView) {
                                AppSettingsView()
                        }

                        Button(action: {
                            print("Run")
                        }) {
                            Image(systemName: "play.fill")
                        }
                }
            )
    }

    private func generateUI() -> some View {
        return Text("UI")
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPreview {
            EditorView()
        }
    }
}
