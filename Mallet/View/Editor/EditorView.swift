//
//  EditorView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/30.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @State private var showAppSettingsView = false

    @State private var appViewOffset = CGSize.zero

    @State private var appViewScale: CGFloat = 1

    let closeEditor: () -> Void

    var body: some View {
        ZStack {
            GeometryReader { geo in
                EditorAppScrollView(scale: self.$appViewScale) {
                    EditorAppView(appViewScale: self.$appViewScale)
                        .environmentObject(self.editorViewModel)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .scaleEffect(self.appViewScale)
                }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .scaleEffect(self.appViewScale)
            }

            GeometryReader { geo in
                EditorModalView(editorGeo: geo)
                    .environmentObject(self.editorViewModel)
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("App Title", displayMode: .inline)
            .navigationBarItems(leading: navigationBarLeadingUI(), trailing: navigationBarTrailingUI())
    }

    private func navigationBarLeadingUI() -> some View {
        Button(action: {
            self.closeEditor()
        }) {
            Text("Done")
                .padding([.top, .bottom], 7)
        }
    }

    private func navigationBarTrailingUI() -> some View {
        HStack(alignment: .center) {
            Button(action: {
                self.showAppSettingsView = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
                .sheet(isPresented: self.$showAppSettingsView) {
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
    }

    private func generateUI() -> some View {
        return Text("UI")
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPreview {
            EditorView(closeEditor: {})
        }
    }
}
