//
//  UISelectionView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/01.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UISelectionView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    let editorGeo: GeometryProxy

    let closeModalView: () -> Void

    @Binding var selectedUIType: MUIType

    @Binding var selectedUIFrame: CGRect

    @Binding var appViewScale: CGFloat

    @Binding var appViewOffset: CGPoint

    private var uiTable: [[MUIType]] {
        [[.text, .button, .input],
         [.slider, .toggle, .space]]
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(uiTable, id: \.self) { uiTableRow in
                HStack {
                    Spacer()
                    ForEach(uiTableRow, id: \.self) { type in
                        self.uiSelectionCell(type: type)
                    }
                }
            }

            Spacer()
        }
    }

    private func uiSelectionCell(type: MUIType) -> some View {

        let width: CGFloat = 80
        let height: CGFloat = 50

        return Group {
            if type == .space {
                Spacer()
                    .frame(width: width, height: height)
            } else {
                GeometryReader { geo in
                    UISelectionView.generateUI(type: type)
                        .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                        //.frame(width: width, height: height)
                        .background(MUI.defaultValue(type: type).backgroundData.color.toColor)
                        .cornerRadius(MUI.defaultValue(type: type).backgroundData.cornerRadius)
                        .gesture(DragGesture()
                                     .onChanged { value in
                                         self.closeModalView()
                                         self.selectedUIType = type
                                         self.selectedUIFrame.origin.x = geo.frame(in: .global).origin.x + value.translation.width
                                         self.selectedUIFrame.origin.y = geo.frame(in: .global).origin.y + value.translation.height
                                         self.selectedUIFrame.size = CGSize(width: geo.size.width, height: geo.size.height)
                                     }
                                     .onEnded { value in
                                         var offset = self.appViewOffset
                                         offset.x += self.editorGeo.size.width * (1 - self.appViewScale) / 2
                                         offset.y += (self.editorGeo.size.height) * (1 - self.appViewScale) / 2
                                         offset.y += self.editorGeo.safeAreaInsets.top

                                         var frame = MUIRect(self.selectedUIFrame)
                                         frame.x -= self.editorGeo.frame(in: .global).origin.x
                                         frame.y -= self.editorGeo.frame(in: .global).origin.y

                                         frame.x = self.editorGeo.size.width / 2 + ((frame.x + offset.x + frame.width / 2) - self.editorGeo.size.width / 2) / self.appViewScale - frame.width / 2
                                         frame.y = self.editorGeo.size.height / 2 + ((frame.y + offset.y + frame.height / 2) - self.editorGeo.size.height / 2) / self.appViewScale - frame.height / 2

                                         self.editorViewModel.addUI(type: type, frame: frame)
                                         self.selectedUIType = .space
                                         self.selectedUIFrame = CGRect.zero
                                     }
                        )
                }
                    .frame(width: width, height: height)
                    .background(Color.white)
            }

            Spacer()
        }
    }

    static func generateUI(type: MUIType) -> some View {

        var uiData = MUI.defaultValue(type: type)
        uiData.frameData.frame = MUIRect(x: 0, y: 0, width: 80, height: 50)

        return Group {
            if type == .text {
                MUIText(uiData: .constant(uiData))
            } else if type == .button {
                MUIButton(uiData: .constant(uiData))
            } else if type == .input {
                MUIInput(uiData: .constant(uiData))
            } else if type == .slider {
                MUISlider(uiData: .constant(uiData))
            } else if type == .toggle {
                MUIToggle(uiData: .constant(uiData))
            } else if type == .space {
                Spacer()
            }
        }
            .colorScheme(.light)
            .overlay(Color.white.opacity(0.001))
    }
}

/*
struct MUISelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUISelectionView(selectedUIType: .constant(.space), selectedUIFrame: .constant(CGRect.zero))
                .colorScheme(.light)

            MUISelectionView(selectedUIType: .constant(.space), selectedUIFrame: .constant(CGRect.zero))
                .colorScheme(.dark)
        }
    }
}
*/
