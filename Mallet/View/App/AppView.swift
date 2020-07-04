//
//  AppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/19.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct AppView: View {

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.white

                ForEach(self.appViewModel.uiIDs, id: \.self) { id in
                    MUI.putView(uiData: self.appViewModel.getUIDataOf(id), invokeAction: { self.appViewModel.runFunc(funcName: $0) })
                }
            }
                .navigationBarTitle(Text(self.appViewModel.appName), displayMode: .inline)
                .navigationBarItems(leading: self.leadingNavigationBarItems())
        }
            .colorScheme(.light)
            .onAppear {
                self.appViewModel.run()
            }
    }

    private func leadingNavigationBarItems() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            self.appViewModel.exitApp()
        }) {
            Image(systemName: "xmark")
                .padding(.vertical, 10)
                .padding(.trailing, 20)
        }
    }

}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
