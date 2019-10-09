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
    case Block = "Block"
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
                    BlockData(funcType: .ArgContent, funcName: "", contents: [
                        BlockContentData(value: .Label("("), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label(")"), order: -1)
                    ], indent: 0)
                ],

                .Block: [
                    BlockData(funcType: .Block, funcName: "setUIText", contents: [
                        BlockContentData(value: .Label("Set text of"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0),
                ]
            ]
}