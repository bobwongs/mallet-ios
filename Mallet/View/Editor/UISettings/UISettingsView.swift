//
//  UISettingsView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/03.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UISettingsView: View {

    private enum UISettingsMode {
        case property
        case code
    }

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var uiData: MUI

    @State private var settingsMode = UISettingsMode.property

    var body: some View {
        NavigationView {
            VStack {
                if settingsMode == .property {
                    UIPropertyEditingView(uiData: $uiData)
                } else if settingsMode == .code {
                    CodeEditingView()
                }
            }
                .navigationBarItems(leading: headerLeading(), trailing: headerTrailing())
        }
    }

    private func headerLeading() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .fontWeight(.medium)
        }
    }

    private func headerTrailing() -> some View {
        Button(action: {
            if self.settingsMode == .property {
                self.settingsMode = .code
            } else {
                self.settingsMode = .property
            }
        }) {
            if self.settingsMode == .property {
                Text("Edit Code")
            } else {
                Text("Edit Property")
            }
        }
    }
}
