//
//  HomeView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var homeViewModel = HomeViewModel()

    @State private var editorViewModel = EditorViewModel()

    @State private var showingEditor = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(self.homeViewModel.apps, id: \.self) { (app: AppRealmObject) in
                        Group {
                            HomeAppCell(appID: app.appID,
                                        appName: app.appName,
                                        runApp: {},
                                        openEditor: { self.openEditor(appID: app.appID) })
                        }
                    }
                }

                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(10)
                    .padding(.top, 20)
            }
                .navigationBarTitle("My Apps", displayMode: .large)
                .navigationBarItems(trailing:
                                    HStack {
                                        Button(action: {
                                            Storage.createNewApp()
                                        }) {
                                            Image(systemName: "plus")
                                        }
                                    }
                )

            NavigationLink(destination: EditorView(closeEditor: { self.closeEditor() }).environmentObject(editorViewModel),
                           isActive: $showingEditor,
                           label: { EmptyView() })
        }
    }

    private func openEditor(appID: Int) {
        editorViewModel = EditorViewModel(Storage.loadApp(appID: appID))
        showingEditor = true
    }

    private func closeEditor() {
        showingEditor = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HomeView()
            }
                .colorScheme(.dark)

            NavigationView {
                HomeView()
            }
        }
    }
}
