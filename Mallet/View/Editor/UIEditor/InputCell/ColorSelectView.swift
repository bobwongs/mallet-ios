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

    @State private var opacity: Float = 0 {
        didSet {
            print("didSet")
        }
    }

    private let colorPalette: [[MUIColor]] =
        [
            [.init("0098FF"), .init("17E4C8"), .init("57D22F"), .init("FADD2D"), .init("FF5845"), .init("ED549D")],
            [.init("006BB1"), .init("069E93"), .init("1CA702"), .init("F8B002"), .init("EC1E10"), .init("C4246F")],
            [.init("004474"), .init("02706A"), .init("036601"), .init("FF8702"), .init("AC1600"), .init("8E1853")],
            [.init("002E58"), .init("01504E"), .init("014507"), .init("D15403"), .init("750F02"), .init("5A103E")],
            [.init("FFFFFF"), .init("9F9F9F"), .init("616161"), .init("3B3B3B"), .init("000000"), .init("00000000")],
        ]

    var body: some View {
        VStack(spacing: 0) {
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
                    self.opacity = Float(self.color.a) / 2.55
                    self.updateColorCode()
                })
                    .multilineTextAlignment(.trailing)
                    .fixedSize()
            }
                .padding(10)

            opacitySlider()
                .padding(10)

            VStack(spacing: 0) {
                ForEach(colorPalette, id: \.self) { colors in
                    HStack(spacing: 0) {
                        ForEach(colors, id: \.self) { (color: MUIColor) in
                            Button(action: {
                                self.color = color
                                self.colorCode = color.hexCode(withAlpha: false)
                            }) {
                                if (color == MUIColor(r: 0, g: 0, b: 0, a: 0)) {
                                    self.transparentButton()
                                } else {
                                    color.color
                                }
                            }
                                .frame(height: 40)
                                .cornerRadius(0)
                                .colorScheme(.light)
                        }
                    }
                }
            }
                .padding(10)

            Spacer()
        }
            .navigationBarTitle("Select Color", displayMode: .inline)
            .onAppear {
                self.opacity = Float(self.color.a) / 255.0
                self.updateColorCode()
            }
    }

    func opacitySlider() -> some View {
        HStack {
            Text("Opacity")

            Slider(value: $opacity, in: 0.0...100.0, step: 1, onEditingChanged: { _ in
                self.updateColorCode()
            })

            TextField("", value: $opacity,
                      formatter: FractionalNumberFormatter(0.0...100.0, minimumFractionDigits: 0, maximumFractionDigits: 1)
                , onCommit: {
                self.updateColorCode()
            })
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.trailing)
                .frame(width: 50)

            Text("%")
        }
    }

    func transparentButton() -> some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
            }
                .stroke(Color.red, lineWidth: 5)
        }
    }

    func updateColorCode() {
        self.color.a = Int(self.opacity * 2.55)
        self.colorCode = self.color.hexCode(withAlpha: false)
    }

}
