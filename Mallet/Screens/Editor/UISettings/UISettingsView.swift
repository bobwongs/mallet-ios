//
//  UISettingsView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/10.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UISettingsView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Yay")
                }
            }
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                })
                    {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                )
        }
    }
}

struct UISettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UISettingsView()
            .colorScheme(.dark)
    }
}
