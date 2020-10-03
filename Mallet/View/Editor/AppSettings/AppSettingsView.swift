//
//  AppSettingsView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/07.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct AppSettingsView: View {

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var editorViewModel: EditorViewModel

    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("App Name")
                        TextField("App Name", text: $editorViewModel.appName)
                            .multilineTextAlignment(.trailing)
                    }
                }

                /*
                Section {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        AddShortcut().showShortcutScreen(appID: self.editorViewModel.appID, appName: self.editorViewModel.appName)
                    }) {
                        Text("Add icon to home screen")
                    }
                }
                */

                Section {
                    Button(action: {
                        guard let url = editorViewModel.currentAppData.shareURL() else {
                            self.showingAlert = true
                            return
                        }
                        ActivityView.show(items: [url])
                    }) {
                        Text("Copy share link")
                    }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Failed to generate share link"))
                        }
                }
            }
                .navigationBarTitle("App Settings", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                }
                )
        }
            .onDisappear {
                editorViewModel.saveApp()
            }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppSettingsView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .navigationViewStyle(StackNavigationViewStyle())


            AppSettingsView()
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .navigationViewStyle(StackNavigationViewStyle())

            AppSettingsView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .navigationViewStyle(StackNavigationViewStyle())

            AppSettingsView()
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
