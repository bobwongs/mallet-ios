//
//  AppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/11/19.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct AppView: View {

    let appName: String

    @State var uiData: [MUI] = [MUI(uiID: 0, uiName: "Text1", uiType: .text, x: 100, y: 100, width: 100, height: 50)]

    var body: some View {
        NavigationView {
            ZStack {
                ForEach(0..<uiData.count, content: { (index: Int) -> AnyView in

                    let mui = self.uiData[index]

                    switch mui.uiType {

                    case .text:
                        return AnyView(MUITextView())

                    default:
                        fatalError()
                    }
                })
            }
                .navigationBarTitle(Text(appName), displayMode: .inline)
        }
            .colorScheme(.light)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(appName: "App")
    }
}
