//
//  UISelectionView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/01.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct UISelectionView: View {

    let editorGeo: GeometryProxy

    let closeModalView: () -> ()

    let addUI: (MUIType, GeometryProxy) -> ()

    @Binding var selectedUIType: MUIType

    @Binding var selectedUIFrame: CGRect

    @Binding var appViewScale: CGFloat

    @Binding var appViewOffset: CGPoint

    private var uiTable: [[MUIType]] {
        [[.text, .button, .textField],
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
        let width: CGFloat = 75
        let height: CGFloat = 45
        let padding: CGFloat = 8

        return Group {
            if type == .space {
                Spacer()
                    .frame(width: width, height: height)
                    .padding(padding)
            } else {
                VStack {
                    GeometryReader { geo in
                        UISelectionView.generateUI(type: type)
                            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                            .background(MUI.defaultValue(type: type).backgroundData.color.color)
                            .cornerRadius(MUI.defaultValue(type: type).backgroundData.cornerRadius)
                            .gesture(DragGesture()
                                         .onChanged { value in
                                             closeModalView()
                                             selectedUIType = type
                                             selectedUIFrame.origin.x = geo.frame(in: .global).origin.x + value.translation.width
                                             selectedUIFrame.origin.y = geo.frame(in: .global).origin.y + value.translation.height
                                             selectedUIFrame.size = CGSize(width: geo.size.width, height: geo.size.height)
                                         }
                                         .onEnded { value in
                                             var offset = appViewOffset
                                             offset.x += editorGeo.size.width * (1 - appViewScale) / 2
                                             offset.y += (editorGeo.size.height) * (1 - appViewScale) / 2
                                             offset.y += editorGeo.safeAreaInsets.top

                                             var frame = MUIRect(selectedUIFrame)
                                             frame.x -= editorGeo.frame(in: .global).origin.x
                                             frame.y -= editorGeo.frame(in: .global).origin.y

                                             frame.x = editorGeo.size.width / 2 + ((frame.x + offset.x + frame.width / 2) - editorGeo.size.width / 2) / appViewScale - frame.width / 2
                                             frame.y = editorGeo.size.height / 2 + ((frame.y + offset.y + frame.height / 2) - editorGeo.size.height / 2) / appViewScale - frame.height / 2

                                             addUI(type, geo)
                                             selectedUIType = .space
                                             selectedUIFrame = CGRect.zero
                                         }
                            )
                    }
                }
                    .frame(width: width, height: height)
                    .padding(padding)
                    .background(Color(.systemGray5).colorScheme(.light))
                    .cornerRadius(10)

            }

            Spacer()
        }
    }

    static func generateUI(type: MUIType) -> some View {

        var uiData = MUI.defaultValue(type: type)
        uiData.frameData = .init(MUIRect(x: 0, y: 0, width: 80, height: 50))

        return Group {
            if type == .text {
                MUIText(uiData: .constant(uiData))
            } else if type == .button {
                MUIButton(uiData: .constant(uiData))
            } else if type == .textField {
                MUITextField(uiData: .constant(uiData))
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

extension UISelectionView: Equatable {

    public static func ==(lhs: UISelectionView, rhs: UISelectionView) -> Bool {
        lhs.editorGeo.frame(in: .global) == rhs.editorGeo.frame(in: .global) &&
            lhs.selectedUIType == rhs.selectedUIType &&
            lhs.selectedUIFrame == rhs.selectedUIFrame &&
            lhs.appViewScale == rhs.appViewScale &&
            lhs.appViewOffset == rhs.appViewOffset
    }

}
