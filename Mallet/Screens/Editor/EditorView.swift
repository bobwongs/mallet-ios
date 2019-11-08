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

    var body: some View {
        VStack {
            Spacer()
        }
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
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditorView()
            }
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .navigationViewStyle(StackNavigationViewStyle())


            NavigationView {
                EditorView()
            }
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .navigationViewStyle(StackNavigationViewStyle())

            NavigationView {
                EditorView()
            }
                .colorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .navigationViewStyle(StackNavigationViewStyle())

            NavigationView {
                EditorView()
            }
                .colorScheme(.light)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
