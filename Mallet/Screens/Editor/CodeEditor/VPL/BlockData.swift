//
//  BlockData.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/06.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

/*
enum BlockType: CaseIterable {
    //case Print
    case SetUIText
    case While
    case IF
    case ELSE
    case Assign
    case Sleep
    case Variable
    case Declare
    case Repeat
    case AddToList
    case ShowWebPage
    case ShowInTableView
    case CopyToClipboard
    case Tweet
    case AddMemo
}
*/

enum BlockCategory: String, CaseIterable {
    case Variable = "Variable"
    case Control = "Control"
    case UI = "UI"
    case Debug = "Debug"
}

enum BlockType {
    case ArgContent
    case Block
    case Assign
    case Declare
    case Bracket
}

enum BlockContentType {
    case Label(String)
    case Arg([ArgContentType])
}

enum ArgContentType {
    case Input(String)
    case Text(String)
    case Block(BlockData)
    case Variable(String)
}

struct BlockContentData {
    let value: BlockContentType
    let order: Int
}

struct BlockData {
    //let blockType: BlockType
    let funcType: BlockType
    let funcName: String
    var contents: [BlockContentData]
    var indent: Int

    /*
    init(blockType: BlockType, funcType: FuncType, funcName: String, contents: [BlockContentData], indent: Int) {

        self.blockType = blockType
        self.funcType = funcType
        self.contents = contents
        self.funcName = funcName
        self.indent = indent
    }
    */
}

struct DefaultBlocks {
    static let blocks: [BlockCategory: [BlockData]] =
            [
                .Variable: [
                    BlockData(funcType: .Assign, funcName: "", contents: [
                        BlockContentData(value: .Label("Set"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "add", contents: [
                        BlockContentData(value: .Label("Add"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0)
                    ], indent: 0),

                    BlockData(funcType: .ArgContent, funcName: "get", contents: [
                        BlockContentData(value: .Arg([]), order: 1),
                        BlockContentData(value: .Label("th item of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0),

                    BlockData(funcType: .ArgContent, funcName: "size", contents: [
                        BlockContentData(value: .Label("Size of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "insert", contents: [
                        BlockContentData(value: .Label("Insert"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1),
                        BlockContentData(value: .Label("at"), order: -1),
                        BlockContentData(value: .Arg([]), order: 2),
                        BlockContentData(value: .Label("of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "remove", contents: [
                        BlockContentData(value: .Label("Remove item at"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1),
                        BlockContentData(value: .Label("in"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0)
                    ], indent: 0),
                ],

                .Control: [
                    BlockData(funcType: .Bracket, funcName: "repeat", contents: [
                        BlockContentData(value: .Label("Repeat"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("times"), order: -1),
                    ], indent: 0),


                    BlockData(funcType: .Bracket, funcName: "while", contents: [
                        BlockContentData(value: .Label("While"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0),


                    BlockData(funcType: .Bracket, funcName: "if", contents: [
                        BlockContentData(value: .Label("If"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0),


                    BlockData(funcType: .Bracket, funcName: "else", contents: [
                        BlockContentData(value: .Label("Else"), order: -1),
                    ], indent: 0),

                    BlockData(funcType: .Bracket, funcName: "sleep", contents: [
                        BlockContentData(value: .Label("Wait"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("seconds"), order: -1),
                    ], indent: 0),
                ],

                .UI: [
                    BlockData(funcType: .Block, funcName: "setUIValue", contents: [
                        BlockContentData(value: .Label("Set value of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "setUIText", contents: [
                        BlockContentData(value: .Label("Set text of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),

                    BlockData(funcType: .ArgContent, funcName: "getUIValue", contents: [
                        BlockContentData(value: .Label("Value of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "setUIWidth", contents: [
                        BlockContentData(value: .Label("Set width of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "setUIHeight", contents: [
                        BlockContentData(value: .Label("Set height of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),

                    BlockData(funcType: .Block, funcName: "setUIVFontColor", contents: [
                        BlockContentData(value: .Label("Set font color of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),


                    BlockData(funcType: .Block, funcName: "setUIFontSize", contents: [
                        BlockContentData(value: .Label("Set font size of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),


                    BlockData(funcType: .Block, funcName: "setUITextAlignment", contents: [
                        BlockContentData(value: .Label("Set text alignment of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),

                ],

                .Debug: [
                    BlockData(funcType: .Block, funcName: "print", contents: [
                        BlockContentData(value: .Label("Print"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                    ], indent: 0)
                ]

            ]
}