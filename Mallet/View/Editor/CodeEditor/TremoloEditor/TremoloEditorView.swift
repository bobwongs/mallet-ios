//
//  TremoloEditorView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/05/07.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI
import Tremolo

struct TremoloEditorView: View {

    @StateObject var tremolo = Self.tremolo

    @Binding private var uiData: MUI

    @State private var selectedCodeIdx = 0

    private let codes: [Binding<MUIAction>]

    init(uiData: Binding<MUI>) {
        self._uiData = uiData
        codes = MUI.getCode(from: uiData)
    }

    var body: some View {
        Group {
            if codes.count == 0 {
                Text("There is no code to edit.")
            } else {
                VStack {
                    TabBar(tabNames: codes.map { $0.wrappedValue.name }, selectedIdx: $selectedCodeIdx) { idx in

                    }
                    TremoloView(tremolo)
                }
            }
        }
    }

}

extension TremoloEditorView {

    static let tremolo = Tremolo(
        blockCategories: blockCategories,
        blocks: [],
        variables: [],
        blockStyles: blockStyles
    )

    static let blockCategories: [BlockCategory] =
        [
            BlockCategory(
                name: "UI",
                templates: [
                    bSetValue,
                    bGetValue,
                    bSetText,
                    bGetText,
                ]
            ),

            BlockCategory(
                name: "Variable",
                templates: [
                    bSetVar,
                ]
            ),

            BlockCategory(
                name: "Utility",
                templates: [
                    bPrint,
                    bString,
                    bMath,
                ]
            ),

            BlockCategory(
                name: "Control",
                templates: [
                    bRepeat,
                ]
            ),
        ]

    static let blockStyles: [Type: BlockStyle] = [
        .void: .defaultStyle,
        .custom("value"): BlockStyle(color: .systemTeal, textColor: .black, argumentAreaColor: .systemTeal)
    ]
}

extension TremoloEditorView {

    static let bPrint =
        BlockTemplate(
            name: "print",
            type: .void,
            argTypes: [.value],
            contents: [[.label("Print"), .arg(0)]]
        )

    static let bSetText =
        BlockTemplate(
            name: "setText",
            type: .void,
            argTypes: [.value, .value],
            contents: [[.label("Set text of"), .arg(0), .label("to"), .arg(1)]]
        )

    static let bGetText =
        BlockTemplate(
            name: "getText",
            type: .custom("value"),
            argTypes: [.value],
            contents: [[.label("Get text of"), .arg(0)]]
        )

    static let bSetValue =
        BlockTemplate(
            name: "setValue",
            type: .void,
            argTypes: [.value, .mathValue],
            contents: [[.label("Set value of"), .arg(0), .label("to"), .arg(1)]]
        )

    static let bGetValue =
        BlockTemplate(
            name: "getText",
            type: .custom("value"),
            argTypes: [.value],
            contents: [[.label("Get value of"), .arg(0)]]
        )
    static let bString =
        BlockTemplate(
            name: "string",
            type: .custom("value"),
            argTypes: [.stringValue],
            contents: [[.arg(0)]],
            formatter: { "\"\($0[0])\"" },
            style: BlockStyle(color: .white, textColor: .black)
        )

    static let bMath =
        BlockTemplate(
            name: "math",
            type: .custom("value"),
            argTypes: [.mathValue],
            contents: [[.arg(0)]],
            formatter: { $0[0] }
        )

    static let bSetVar =
        BlockTemplate(
            name: "setVar",
            type: .void,
            argTypes: [.variable(type: .custom("value"), name: "Variable"), .value],
            contents: [[.label("Set"), .arg(0), .label("to"), .arg(1)]],
            formatter: { args in
                "\(args[0]) = \(args[1])"
            },
            declarableVariableIndex: 0)

    static let bRepeat =
        BlockTemplate(
            name: "repeat",
            type: .void,
            argTypes: [.mathValue, .code],
            contents: [
                [.label("Repeat"), .arg(0), .label("times")],
                [.arg(1)]
            ]
        )

}
