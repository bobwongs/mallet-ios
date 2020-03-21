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
        ZStack {
            NavigationLink(destination: EditorView(closeEditor: { self.closeEditor() }).environmentObject(editorViewModel),
                           isActive: $showingEditor,
                           label: { EmptyView() })

            appList()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.editorViewModel = EditorViewModel(Storage.createNewApp())
                        self.showingEditor = true
                    }) {
                        Circle()
                            .foregroundColor(.blue)
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            )
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 20)
                    }
                }
            }
        }
            .navigationBarTitle("My Apps", displayMode: .large)
            .navigationBarItems(leading:
                                EditButton(),
                                trailing:
                                HStack {
                                    Button(action: {
                                        print("Settings")
                                    }) {
                                        Image(systemName: "gear")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 22, height: 22)
                                            .padding(10)
                                    }
                                }
            )
    }

    private func appList() -> some View {
        List {
            ForEach(self.homeViewModel.apps, id: \.appID) { (app: HomeViewModel.AppInfo) in
                HomeAppCell(appID: app.appID,
                            appName: app.appName,
                            runApp: { print("Run App") },
                            openEditor: { self.openEditor(appID: app.appID) },
                            deleteApp: { Storage.deleteApp(appID: app.appID) }
                )
            }
                .onMove { (idxs, to) in
                    for idx in idxs {
                        if idx < to {
                            Storage.moveApp(idx, to - 1)
                        } else {
                            Storage.moveApp(idx, to)
                        }
                    }
                }
                .onDelete { idxs in
                    for idx in idxs {
                        Storage.deleteApp(appID: self.homeViewModel.apps[idx].appID)
                    }
                }

            Spacer()
                .frame(height: 80)
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
