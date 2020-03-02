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

    @State var showingAppSettingsView = false

    var body: some View {
        ZStack {
            EditorAppView()
                .environmentObject(editorViewModel)

            ZStack {
                EditorModalView()

                EditorFooterView()
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("App Title", displayMode: .inline)
            .navigationBarItems(trailing: navigationBarUI())
    }

    private func navigationBarUI() -> some View {
        HStack(alignment: .center) {

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
