//
//  EditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorView: View {

    @State var uiData = [MUI(uiID: 0, uiName: "Text", uiType: .text, frame: MRect(x: 100, y: 100, width: 200, height: 100)),
        MUI(uiID: 1, uiName: "Yay", uiType: .text, frame: MRect(x: 100, y: 200, width: 200, height: 100)),
        MUI(uiID: 2, uiName: "Button", uiType: .button, frame: MRect(x: 200, y: 200, width: 100, height: 100))
    ]

    @State var showingAppSettingsView = false

    var body: some View {
        ZStack {
            EditorAppView(uiData: $uiData)

            ZStack {
                EditorModalView()

                EditorFooterView()
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("App Title", displayMode: .inline)
            .navigationBarItems(trailing:
                    HStack (alignment: .center) {

                        Button(action: {
                            self.showingAppSettingsView = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                            .sheet(isPresented: self.$showingAppSettingsView) {
                                AppSettingsView()
                        }

                        Spacer()
                            .frame(width: 20)

                        Button(action: {
                            print("Run")
                        }) {
                            Image(systemName: "play.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
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
