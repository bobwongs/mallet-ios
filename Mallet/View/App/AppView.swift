//
//  AppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/19.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct AppView: View {

    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Spacer()
            }
                .navigationBarTitle(Text(appViewModel.appName), displayMode: .inline)
                .navigationBarItems(leading:
                                    Button(action: {
                                        self.appViewModel.exitApp()
                                    }) {
                                        Image(systemName: "xmark")
                                    })
        }
            .colorScheme(.light)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
