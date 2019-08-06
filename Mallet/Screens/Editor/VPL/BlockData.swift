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
    case SetUIText
    case Sleep
}

enum BlockContentType {
    case Label
    case InputSingleVariable
    case InputAll
}

struct BlockContentData {
    let type: BlockContentType
    let value: String
    let order: Int
}

struct BlockData {
    let blockType: BlockType
    let funcName: String
    var contents: [BlockContentData]
    var indent: Int

    init(blockType: BlockType, funcName: String, contents: [BlockContentData], indent: Int) {
        self.blockType = blockType
        self.contents = contents
        self.funcName = funcName
        self.indent = indent
    }
}