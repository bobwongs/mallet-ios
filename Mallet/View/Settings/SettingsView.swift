//
//  SettingsView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/21.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                EmptyView()
            }
                .listStyle(GroupedListStyle())
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                })
        }
    }
}
