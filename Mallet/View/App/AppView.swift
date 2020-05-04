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
                self.spacer(geo: geo)
                NavigationView {
                    ZStack {
                        Color.white

                        ForEach(self.appViewModel.uiIDs, id: \.self) { id in
                            return MUI.generateView(uiData: self.appViewModel.getUIDataOf(id))
                        }
                    }
                        .navigationBarTitle(Text(self.appViewModel.appName), displayMode: .inline)
                        .navigationBarItems(leading: self.leadingNavigationBarItems())
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

    private func spacer(geo: GeometryProxy) -> some View {
        Group {
            if (self.hideAppView) {
                Color.clear
                    .frame(height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func leadingNavigationBarItems() -> some View {
        Button(action: {
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
