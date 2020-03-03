//
//  HomeView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/28.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct HomeAppCell: View {

    var appID: Int

    var appName: String

    let runApp: () -> Void

    let openEditor: () -> Void

    var body: some View {
        Button(action: {
            self.runApp()
        }) {
            VStack {
                HStack {
                    Text(self.appName)
                        .foregroundColor(Color(UIColor.label))
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.openEditor()
                    }) {
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                        .frame(width: 25, height: 25)
                }

            }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(Color(UIColor.systemFill))
                .cornerRadius(10)
        }
    }

    func moveToEditor() {

    }
}

struct HomeView: View {

    struct app {
        let appID: Int
        let appName: String
    }

    @State private var appData = [app]()

    @State private var editorViewModel = EditorViewModel.testModel

    @State private var showingEditor = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(self.appData, id: \.appID) { appData in
                        Group {
                            HomeAppCell(appID: appData.appID,
                                        appName: appData.appName,
                                        runApp: {},
                                        openEditor: { self.openEditor(appID: appData.appID) })
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
                                            print("Add app")
                                        }) {
                                            Image(systemName: "plus")
                                        }
                                    }
                )

            NavigationLink(destination: EditorView(closeEditor: { self.closeEditor() }).environmentObject(editorViewModel),
                           isActive: $showingEditor,
                           label: { EmptyView() })
        }
            .onAppear(perform: {
                self.reloadAppData()
            })
    }

    private func reloadAppData() {
        self.appData = [app(appID: 0, appName: "Awesome App"), app(appID: 1, appName: "Cool App")]
    }

    private func openEditor(appID: Int) {
        editorViewModel = .testModel
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
