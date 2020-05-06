//
//  ColorSelectView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/23.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

struct ColorSelectView: View {

    @Binding var color: MUIColor

    @State private var colorCode = ""

    private let defaultColors: [[UIColor]] = [[.init(red: 0, green: 0, blue: 0, alpha: 1), .init(red: 1, green: 1, blue: 1, alpha: 1), .systemGray],
                                              [.systemYellow, .systemOrange, .systemRed],
                                              [.systemPurple, .systemBlue, .systemGreen]]

    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .foregroundColor(color.color)
                    .frame(width: 50, height: 30)
                    .cornerRadius(5)

                Spacer()

                Text("#")
                TextField("", text: $colorCode, onEditingChanged: { _ in
                }, onCommit: {
                    self.color = MUIColor(self.colorCode)
                })
                    .multilineTextAlignment(.trailing)
            }
                .padding(10)

            VStack {
                ForEach(defaultColors, id: \.self) { colors in
                    HStack {
                        ForEach(colors, id: \.self) { (color: UIColor) in
                            Button(action: {
                                self.color = MUIColor(color)
                                self.colorCode = self.color.hexCode
                            }) {
                                Color(color)
                            }
                                .frame(height: 50)
                                .cornerRadius(5)
                                .colorScheme(.light)
                        }
                    }
                }
            }
                .padding(.horizontal, 10)
        }
            .navigationBarTitle("Select Color", displayMode: .inline)
            .onAppear {
                self.colorCode = self.color.hexCode
            }
    }

}
