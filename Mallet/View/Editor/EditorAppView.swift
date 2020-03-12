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
                EditorUIOverlayView(uiData: self.$editorViewModel.uiData[idx],
                                    selectedUIID: self.$editorViewModel.selectedUIID) {
                    self.generateUI(index: idx)
                }
            }

            ForEach(0..<editorViewModel.uiData.count, id: \.self) { idx in
                Group {
                    if self.editorViewModel.uiData[idx].uiID == self.editorViewModel.selectedUIID {
                        UIFrameEditingView(frameData: self.$editorViewModel.uiData[idx].frameData,
                                           appViewScale: self.$appViewScale) {
                            self.generateUI(index: idx)
                        }
                    }
                }
            }
        }
            .padding(300)
            .background(Color.purple)
            .edgesIgnoringSafeArea(.bottom)
            .colorScheme(.light)
            .onTapGesture {
                self.editorViewModel.selectedUIID = nil
            }
    }

    func generateUI(index: Int) -> some View {

        let uiData = $editorViewModel.uiData[index]

        let uiType = editorViewModel.uiData[index].uiType

        let frameData = editorViewModel.uiData[index].frameData

        let backgroundData = editorViewModel.uiData[index].backgroundData

        let uiView = Group {
            if uiType == .text {
                MUIText(uiData: uiData)
            } else if uiType == .button {
                MUIButton(uiData: uiData)
            } else if uiType == .input {
                MUIInput()
            } else if uiType == .slider {
                MUISlider()
            } else if uiType == .toggle {
                MUIToggle(uiData: uiData)
            } else {
                fatalError()
            }
        }

        return Group {
            if frameData.lockWidth && frameData.lockHeight {
                uiView
            } else if frameData.lockWidth {
                uiView
                    .frame(height: frameData.frame.height)
            } else if frameData.lockHeight {
                uiView
                    .frame(width: frameData.frame.width)
            } else {
                uiView
                    .frame(width: frameData.frame.width, height: frameData.frame.height)
            }
        }
            .background(backgroundData.color.toColor)
            .cornerRadius(backgroundData.cornerRadius)


        /*
        return MUIEditorFrameView(uiData: $editorViewModel.uiData[index], selectedUIID: $editorViewModel.selectedUIID, appViewScale: $appViewScale) {
            if uiType == .text {
                MUIText(uiData: uiData)
            } else if uiType == .button {
                MUIButton(uiData: uiData)
            } else if uiType == .input {
                MUIInput()
            } else if uiType == .slider {
                MUISlider()
            } else if uiType == .toggle {
                MUIToggle(uiData: uiData)
            } else {
                fatalError()
            }
        }
        */
    }
}

/*
struct EditorAppView_Previews: PreviewProvider {
    static var previews: some View {
        EditorAppView(uiData: .constant([]))
    }
}
*/
