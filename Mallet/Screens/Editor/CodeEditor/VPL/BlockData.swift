//
//  BlockData.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/06.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

enum BlockType: CaseIterable {
    case Print
    case Variable
    case SetUIText
    case Sleep
    case Assign
    case Declare
    case Repeat
    case While
    case IF
    case ELSE
    case AddToList
    case ShowWebPage
    case ShowInTableView
    case CopyToClipboard
    case Tweet
    case AddMemo
}

enum FuncType {
    case Func
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
}

struct BlockContentData {
    let value: BlockContentType
    let order: Int
}

struct BlockData {
    let blockType: BlockType
    let funcType: FuncType
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