//
//  Text2VPL.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/11.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import Foundation

class Text2VPL {
    private struct ConvertedFormulaData {
        let formulaData: [ArgContentType]
        let codeSize: Int
    }

    private struct ConvertedFuncData {
        let blockData: BlockData
        let codeSize: Int
    }

    private var variables = Set<String>()

    private var blockData = [BlockData]()

    private var code = [String]()

    private var blockDataDictionary = [String: BlockData]()

    func Convert(codeStr: String) -> [BlockData] {
        blockData = [BlockData]()

        guard let splitCodeNSMutableArray = ConverterObjCpp().splitCode("{\(codeStr)}") else {
            return blockData
        }

        code = [String]()
        for obj in splitCodeNSMutableArray {
            code.append((obj as? String) ?? "")
        }

        self.BlockData2Dictionary()

        print(ConvertCodeBlock(codeFirstIndex: 0, indent: 0))

        return blockData
    }

    private func ConvertCodeBlock(codeFirstIndex: Int, indent: Int) -> Int? {
        var codeIndex = codeFirstIndex

        let isBlock: Bool!

        if code[codeIndex] == "{" {
            isBlock = true

            codeIndex += 1
        } else {
            isBlock = false
        }

        while code[codeIndex] != "}" {
            let token = code[codeIndex]

            var codeSize = 0

            switch token {
            case "{":
                if let codeSize = ConvertCodeBlock(codeFirstIndex: codeIndex, indent: indent) {
                    return nil
                } else {
                    codeSize = 2 + codeSize
                }

            default:
                if code[codeIndex + 1] == "=" {

                    let varName = token

                    codeIndex += 2

                    guard let convertedFormulaData = ConvertFormula(codeFirstIndex: codeIndex, isInBracket: false) else {
                        return nil
                    }

                    codeIndex += convertedFormulaData.codeSize

                    let value = convertedFormulaData.formulaData

                    guard var thisBlockData = self.blockDataDictionary[""] else {
                        return nil
                    }

                    thisBlockData.contents[1] = BlockContentData(value: .Arg([.Variable(varName)]), order: 0)
                    thisBlockData.contents[3] = BlockContentData(value: .Arg(value), order: 0)

                    thisBlockData.indent = indent

                    self.blockData.append(thisBlockData)

                } else {
                    guard let convertedFuncData = self.ConvertFunc(codeFirstIndex: codeIndex, indent: indent) else {
                        return nil
                    }

                    codeIndex += convertedFuncData.codeSize

                    self.blockData.append(convertedFuncData.blockData)

                    switch convertedFuncData.blockData.funcType {
                    case .Block:

                        break

                    case .Bracket:
                        guard let codeSize = self.ConvertCodeBlock(codeFirstIndex: codeIndex, indent: indent + 1) else {
                            return nil
                        }

                        codeIndex += codeSize

                        break

                    default:
                        break
                    }

                }

            }

            if !isBlock {
                break
            }
        }

        if isBlock && code[codeIndex] == "}" {
            codeIndex += 1
        }

        return codeIndex - codeFirstIndex
    }


    private func ConvertFunc(codeFirstIndex: Int, indent: Int? = nil) -> ConvertedFuncData? {
        if var thisBlockData = self.blockDataDictionary[self.code[codeFirstIndex]] {

            var args = [[ArgContentType]]()

            var codeIndex = codeFirstIndex + 1

            if self.code[codeIndex] == "(" {

                //             v
                // funcName ( arg1 , arg2 )
                //             ^
                codeIndex += 1

                while (codeIndex < code.count) {

                    guard let convertedFormulaData = ConvertFormula(codeFirstIndex: codeIndex, isInBracket: false) else {
                        return nil
                    }

                    args.append(convertedFormulaData.formulaData)

                    codeIndex += convertedFormulaData.codeSize

                    if code[codeIndex] == "," {
                        codeIndex += 1
                    } else if code[codeIndex] == ")" {
                        codeIndex += 1
                        break
                    } else {
                        return nil
                    }
                }
            }

            for argIndex in 0..<thisBlockData.contents.count {
                switch thisBlockData.contents[argIndex].value {
                case .Label(_):
                    break

                case .Arg(_):
                    let order = thisBlockData.contents[argIndex].order
                    thisBlockData.contents[argIndex] = BlockContentData(value: .Arg(args[order]), order: order)
                }

            }

            thisBlockData.indent = indent ?? 0

            return ConvertedFuncData(blockData: thisBlockData, codeSize: codeIndex - codeFirstIndex)
        } else {
            return nil
        }
    }

    private func ConvertFormula(codeFirstIndex: Int, isInBracket: Bool) -> ConvertedFormulaData? {

        var argContents = [ArgContentType]()

        var codeIndex = codeFirstIndex

        while (codeIndex < self.code.count) {
            if self.code[codeIndex] == "(" {
                codeIndex += 1

                var argContentsInBracket = [ArgContentType]()

                while codeIndex < self.code.count {
                    if self.variables.contains(self.code[codeIndex]) {
                        argContentsInBracket.append(.Variable(self.code[codeIndex]))

                        codeIndex += 1

                    } else if self.code[codeIndex] == "(" {
                        codeIndex += 1

                        guard let convertedFormulaData = ConvertFormula(codeFirstIndex: codeIndex, isInBracket: true) else {
                            return nil
                        }

                        argContentsInBracket.append(convertedFormulaData.formulaData[0])

                        codeIndex += convertedFormulaData.codeSize + 1

                    } else {
                        var inputText = ""
                        while codeIndex < self.code.count && !self.variables.contains(self.code[codeIndex]) && self.code[codeIndex] != "(" && self.code[codeIndex] != ")" {
                            inputText += self.code[codeIndex]
                            codeIndex += 1
                        }

                        argContentsInBracket.append(.Input(inputText))
                    }

                    if self.code[codeIndex] == ")" {
                        break
                    }
                }

                let thisBlockData = BlockData(funcType: .Block, funcName: "", contents: [
                    BlockContentData(value: .Label("("), order: -1),
                    BlockContentData(value: .Arg(argContentsInBracket), order: 0),
                    BlockContentData(value: .Label(")"), order: -1)
                ], indent: 0)

                argContents.append(.Block(thisBlockData))

                codeIndex += 1

            } else if self.blockDataDictionary[code[codeIndex]]?.funcType == .ArgContent {
                guard let convertedFuncData = self.ConvertFunc(codeFirstIndex: codeIndex) else {
                    return nil
                }

                argContents.append(.Block(convertedFuncData.blockData))
                codeIndex += convertedFuncData.codeSize
            } else if self.variables.contains(self.code[codeIndex]) {
                argContents.append(.Variable(code[codeIndex]))
                codeIndex += 1
            } else if self.code[codeIndex].count >= 2 && self.code[codeIndex][0] == "\"" && self.code[codeIndex][self.code[codeIndex].count - 1] == "\"" {
                let str = self.code[codeIndex]
                argContents.append(.Text(String(str[str.index(str.startIndex, offsetBy: 1)..<str.index(str.endIndex, offsetBy: -1)])))
                codeIndex += 1
            } else {
                argContents.append(.Input(self.code[codeIndex]))
                codeIndex += 1
            }

            if isInBracket {
                if self.code[codeIndex] == ")" {
                    break
                }
            } else {
                if code[codeIndex] == "~" {
                    codeIndex += 1
                } else {
                    break
                }
            }
        }

        return ConvertedFormulaData(formulaData: argContents, codeSize: codeIndex - codeFirstIndex)
    }

    private func ConvertValue(codeFirstIndex: Int) -> ArgContentType? {
        return nil
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