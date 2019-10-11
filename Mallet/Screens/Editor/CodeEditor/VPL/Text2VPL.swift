//
//  Text2VPL.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/11.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

/*
class Text2VPL {
    var blockData = [BlockData]()

    var code = [String]()

    var blockDataDictionary = [String: BlockData]()

    func Convert(codeStr: String) -> [BlockData] {
        blockData = [BlockData]()

        guard let splitCodeNSMutableArray = ConverterObjCpp().splitCode(codeStr) else {
            return blockData
        }

        code = [String]()
        for obj in splitCodeNSMutableArray {
            code.append((obj as? String) ?? "")
        }

        var codeIndex = 3
        if code[codeIndex] == ")" {
            codeIndex += 1
        } else {
            while code[codeIndex] != "{" {
                codeIndex += 2
            }
        }

        ConvertCodeBlock(codeFirstIndex: codeIndex, indent: 0)

        return blockData
    }

    func ConvertCodeBlock(codeFirstIndex: Int, indent: Int) -> Int {
        var codeBlockSize = 0

        var codeIndex = codeFirstIndex

        let isBlock: Bool!

        if code[codeIndex] == "{" {
            isBlock = true

            codeIndex += 1
            codeBlockSize += 2
        } else {
            isBlock = false
        }

        while code[codeIndex] != "}" {
            let token = code[codeIndex]

            var codeSize = 0

            switch token {
            case "{":
                codeSize = 2 + ConvertCodeBlock(codeFirstIndex: codeIndex, indent: indent)

            default:
                if code[codeIndex + 1] == "=" {

                } else {
                    if let block = blockDataDictionary[token] {

                        switch block.funcType {
                        case .Block:
                            let argData =

                            break

                        case .Bracket:
                            break

                        default:
                            break
                        }

                    } else {
                        fatalError("Unable to convert")
                    }
                }
            }
        }

        return codeBlockSize
    }

    private func ConvertFuncArg(codeFirstIndex: Int) -> [ArgContentType] {
        var argContentData = [ArgContentType]()

        return argContentData
    }

    private func ConvertFormula(codeFirstIndex: Int) -> ArgContentType {
        /*
        1.最初に~で分割
        2.文字列か数字か変数かを適当に判別
        3.括弧で囲まれていればその中身を変換 変数であれば変数に それ以外ならArgInput

        */

        let argContentData = ArgContentType

        return argContentData
    }

    private func ConvertValue(codeFirstIndex: Int) -> ArgContentType {
    }

    private func BlockData2Dictionary() {
        blockDataDictionary = [String: BlockData]()

        for blockCategory in DefaultBlocks.blocks {
            for block in blockCategory.value {
                if block.funcName == "" {
                    continue
                }

                blockDataDictionary[block.funcName] = block
            }
        }
    }
}
*/