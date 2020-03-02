//
//  ContentView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/27.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var showingEditor = false

    @State private var editorViewModel = EditorViewModel.testModel

    var body: some View {
        NavigationView {
            HomeView(openEditor: { id in self.openEditor(appID: id) })
        }
            .overlay(
                VStack {
                    if showingEditor {
                        EditorView(closeEditor: { self.closeEditor() })
                            .environmentObject(self.editorViewModel)
                            .transition(.move(edge: .trailing))
                    }
                }
            )
            .navigationViewStyle(StackNavigationViewStyle())
    }

    private func openEditor(appID: Int) {
        editorViewModel = .testModel
        withAnimation(.easeOut(duration: 0.3)) {
            showingEditor = true
        }
    }

    private func closeEditor() {
        withAnimation(.easeOut(duration: 0.2)) {
            showingEditor = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
