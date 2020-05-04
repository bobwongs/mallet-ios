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

    // workaround for the bug of NavigationView's transition
    @State private var hideAppView = true

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                if (self.hideAppView) {
                    Color.clear
                        .frame(height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom)
                        .edgesIgnoringSafeArea(.all)
                }
                NavigationView {
                    ZStack {
                        Spacer()
                    }
                        .navigationBarTitle(Text(self.appViewModel.appName), displayMode: .inline)
                        .navigationBarItems(leading:
                                            Button(action: {
                                                self.appViewModel.exitApp()
                                            }) {
                                                Image(systemName: "xmark")
                                                    .padding(.vertical, 10)
                                                    .padding(.trailing, 20)
                                            })
                }
                    .colorScheme(.light)
            }
        }
            .onAppear {
                withAnimation {
                    self.hideAppView = false
                }
            }
    }

}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
