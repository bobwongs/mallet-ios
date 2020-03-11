//
//  EditorAppView.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/12/01.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Swift
import SwiftUI

struct EditorAppView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    @Binding var appViewScale: CGFloat

    var body: some View {
        ZStack {
            Color.white

            ForEach(0..<editorViewModel.uiData.count, id: \.self) { idx in
                self.generateUI(index: idx)
            }

            ForEach(0..<editorViewModel.uiData.count, id: \.self) { idx in
                Group {
                    if self.editorViewModel.uiData[idx].uiID == self.editorViewModel.selectedUIID {
                        UIFrameEditingView(uiData: self.$editorViewModel.uiData[idx], appViewScale: self.$appViewScale)
                    }
                }
            }
        }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.white)
            .colorScheme(.light)
            .onTapGesture {
                self.editorViewModel.selectedUIID = nil
            }
    }

    func generateUI(index: Int) -> some View {

        let ui = editorViewModel.uiData[index]

        let uiType = ui.uiType

        return MUIEditorFrameView(uiData: $editorViewModel.uiData[index], selectedUIID: $editorViewModel.selectedUIID) {
            if uiType == .text {
                MUIText(textData: self.$editorViewModel.uiData[index].textData)
            } else if uiType == .button {
                MUIButton()
            } else if uiType == .input {
                MUIInput()
            } else if uiType == .slider {
                MUISlider()
            } else if uiType == .toggle {
                MUIToggle()
            } else {
                fatalError()
            }
        }
    }
}

/*
struct EditorAppView_Previews: PreviewProvider {
    static var previews: some View {
        EditorAppView(uiData: .constant([]))
    }
}
*/
