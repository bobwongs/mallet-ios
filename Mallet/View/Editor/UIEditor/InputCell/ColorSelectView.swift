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
                    .foregroundColor(color.toColor)
                    .frame(width: 50, height: 30)
                    .cornerRadius(5)

                Spacer()

                Text("#")
                TextField("", text: $colorCode, onEditingChanged: { _ in

                }, onCommit: {
                    self.string2ColorCode(self.colorCode)
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
                self.colorCode =
                    String(self.color.r, radix: 16) + String(self.color.g, radix: 16) + String(self.color.b, radix: 16)
                if self.color.a != 0 {
                    self.colorCode = String(self.color.a, radix: 16) + self.colorCode
                }
                self.colorCode = self.colorCode.uppercased()
            }
    }

    private func string2ColorCode(_ string: String) {

        let resizedString: String

        if string.count >= 8 {
            resizedString = String(string.prefix(8))
        } else if string.count >= 6 {
            resizedString = "FF" + String(string.prefix(6))
        } else if string.count >= 1 {
            let subStr = String(string.prefix(min(3, string.count)))
            resizedString = "FF" + subStr.map({ "\($0)\($0)" }).joined()
        } else {
            resizedString = "FFFFFFFF"
        }

        guard var number = Int(resizedString, radix: 16) else {
            return
        }

        color.b = number % 256
        number /= 256

        color.g = number % 256
        number /= 256

        color.r = number % 256
        number /= 256

        color.a = number % 256
    }
}
