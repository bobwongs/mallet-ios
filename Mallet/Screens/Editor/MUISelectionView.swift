//
//  MUISelectionView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/01.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct MUISelectionView: View {

    private let rectSize: CGFloat = 80

    private let uiTable: [[MUIType]] = [
        [.text, .button, .input],
        [.slider, .toggle, .space]
    ]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(uiTable, id: \.self) { uiTableRow in
                HStack {
                    Spacer()
                    ForEach(uiTableRow, id: \.self) { type in
                        Group {
                            self.generateUI(type: type)
                                .frame(width: self.rectSize, height: self.rectSize)
                            Spacer()
                        }
                    }
                }
            }

            Spacer()
        }
    }

    func generateUI(type: MUIType?) -> some View {
        return Group {
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
    }
}

struct MUISelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MUISelectionView()
                .colorScheme(.light)

            MUISelectionView()
                .colorScheme(.dark)
        }
    }
}