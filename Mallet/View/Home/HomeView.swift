//
//  HomeView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var showingSettings = false

    var body: some View {
        ZStack {
            NavigationLink(destination: EditorView(closeEditor: homeViewModel.closeEditor).environmentObject(homeViewModel.editorViewModel),
                           isActive: $homeViewModel.showingEditor,
                           label: { EmptyView() })

            appList()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        homeViewModel.openEditor()
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
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .navigationBarTitle("My Apps", displayMode: .large)
            .navigationBarItems(leading:
                                EditButton(),
                                trailing:
                                HStack {
                                    Button(action: {
                                        self.showingSettings = true
                                    }) {
                                        Image(systemName: "gearshape")
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
            ForEach(homeViewModel.apps, id: \.appID) { (app: HomeViewModel.AppInfo) in
                HomeAppCell(appID: app.appID,
                            appName: app.appName,
                            runApp: { homeViewModel.runApp(id: app.appID) },
                            openEditor: { homeViewModel.openEditor(appID: app.appID) },
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
                        Storage.deleteApp(appID: homeViewModel.apps[idx].appID)
                    }
                }

            Spacer()
                .frame(height: 80)
        }
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
