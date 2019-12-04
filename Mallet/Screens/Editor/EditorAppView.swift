//
//  EditorAppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct EditorAppView: View {

    @Binding var uiData: [MUI]

    var body: some View {
        ZStack {
            ForEach(0..<uiData.count) { index in
                self.generateUI(index: index)
            }
        }
            .background(Color.white)
            .colorScheme(.light)
    }

    func generateUI(index: Int) -> some View {

        let ui = uiData[index]

        let uiType = ui.uiType

        return Group {
            if uiType == .text {
                MEditorText()
            }
            else if uiType == .button {
                MEditorButton()
            }
            else if uiType == .input {
                MEditorInput()
            }
            else if uiType == .slider {
                MEditorSlider()
            }
            else if uiType == .toggle {
                MEditorToggle()
            }
            else {
                fatalError()
            }
        }
            .frame(width: CGFloat(ui.width), height: CGFloat(ui.height))
            .position(x: CGFloat(ui.x), y: CGFloat(ui.y))
    }
}

struct EditorAppView_Previews: PreviewProvider {
    static var previews: some View {
        EditorAppView(uiData: .constant([]))
    }
}
