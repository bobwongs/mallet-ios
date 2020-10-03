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

                ForEach(appViewModel.uiIDs, id: \.self) { id in
                    MUI.putView(uiData: appViewModel.getUIDataOf(id), invokeAction: { appViewModel.runFunc(funcName: $0) })
                }
            }
                .navigationBarTitle(Text(appViewModel.appName), displayMode: .inline)
                .navigationBarItems(leading: leadingNavigationBarItems())
        }
            .colorScheme(.light)
            .onAppear {
                appViewModel.run()
            }
    }

    private func leadingNavigationBarItems() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            appViewModel.exitApp()
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
