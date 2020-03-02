//
//  MUISelectionView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/01.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUISelectionView: View {

    @EnvironmentObject var editorViewModel: EditorViewModel

    let editorGeo: GeometryProxy

    @Binding var selectedUIType: MUIType

    @Binding var selectedUIFrame: CGRect

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
                    MUISelectionView.generateUI(type: type)
                        .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                        .gesture(DragGesture()
                                     .onChanged { value in
                                         self.selectedUIType = type
                                         self.selectedUIFrame.origin.x = geo.frame(in: .global).origin.x + value.translation.width
                                         self.selectedUIFrame.origin.y = geo.frame(in: .global).origin.y + value.translation.height
                                         self.selectedUIFrame.size = geo.size
                                     }
                                     .onEnded { value in
                                         var frame = MRect(self.selectedUIFrame)
                                         frame.x -= Float(self.editorGeo.frame(in: .global).origin.x)
                                         frame.y -= Float(self.editorGeo.frame(in: .global).origin.y)

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
        Group {
            if type == .text {
                MUIText()
            } else if type == .button {
                MUIButton()
            } else if type == .input {
                MUIInput()
            } else if type == .slider {
                MUISlider()
            } else if type == .toggle {
                MUIToggle()
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
