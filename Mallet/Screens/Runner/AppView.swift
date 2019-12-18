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

    @State var uiData: [MUI] = []

    var body: some View {
        NavigationView {
            ZStack {
                ForEach(0..<uiData.count) { index in
                    self.generateUI(index: index)
                }
            }
                .navigationBarTitle(Text(appName), displayMode: .inline)
                .navigationBarItems(leading:
                        Button(action: { print("Quit App") }) { Image(systemName: "xmark") })
        }
            .colorScheme(.light)
    }

    func generateUI(index: Int) -> some View {
        let ui = uiData[index]

        let uiType = ui.uiType

        return Group {
            if uiType == .text {
                MUIText()
            }
            else if uiType == .button {
                MUIButton()
            }
            else if uiType == .input {
                MUIInput()
            }
            else if uiType == .slider {
                MUISlider()
            }
            else if uiType == .toggle {
                MUIToggle()
            }
            else {
                fatalError()
            }
        }
            .frame(width: CGFloat(ui.frame.width), height: CGFloat(ui.frame.height))
            .background(Color.pink)
            .position(x: CGFloat(ui.frame.midX), y: CGFloat(ui.frame.midY))
    }
}

struct AppView_Previews: PreviewProvider {

    static var previews: some View {
        AppView(appName: "App")
    }
}
