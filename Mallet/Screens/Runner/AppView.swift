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
                MUITextView()
            }
            else if uiType == .button {
                MUIButtonView()
            }
            else if uiType == .input {
                MUIInputView()
            }
            else if uiType == .slider {
                MUISliderView()
            }
            else if uiType == .toggle {
                MUIToggleView()
            }
            else {
                fatalError()
            }
        }
            .frame(width: CGFloat(ui.width), height: CGFloat(ui.height))
            .background(Color.pink)
            .position(x: CGFloat(ui.x), y: CGFloat(ui.y))
    }
}

struct AppView_Previews: PreviewProvider {

    static var previews: some View {
        AppView(appName: "App")
    }
}
