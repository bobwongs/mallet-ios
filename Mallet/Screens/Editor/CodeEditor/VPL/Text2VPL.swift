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
        let formulaData: ArgContentType
        let codeSize: Int
    }

    private struct ConvertedArgData {
        let argData: [ArgContentType]
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

    private let operators: Set = ["==", "!=", ">=", "<=", "&&", "||", ">", "<", "=", "+", "-", "*", "/", "%", "&", "!", "~"]

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

        ConvertCodeBlock(codeFirstIndex: 0, indent: 0)

        print(blockData)

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

                    guard let convertedArgData = ConvertArg(codeFirstIndex: codeIndex) else {
                        return nil
                    }

                    codeIndex += convertedArgData.codeSize

                    let value = convertedArgData.argData

                    var thisBlockData = BlockData(funcType: .Assign, funcName: "", contents: [
                        BlockContentData(value: .Label("Set"), order: -1),
                        BlockContentData(value: .Arg([]), order: 0),
                        BlockContentData(value: .Label("to"), order: -1),
                        BlockContentData(value: .Arg([]), order: 1)
                    ], indent: 0)

                    thisBlockData.contents[1] = BlockContentData(value: .Arg([.Variable(varName)]), order: 0)
                    thisBlockData.contents[3] = BlockContentData(value: .Arg(value), order: 1)

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

                    guard let convertedArgData = ConvertArg(codeFirstIndex: codeIndex) else {
                        return nil
                    }

                    args.append(convertedArgData.argData)

                    codeIndex += convertedArgData.codeSize

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

    private func ConvertArg(codeFirstIndex: Int) -> ConvertedArgData? {

        var argContents = [ArgContentType]()

        var codeIndex = codeFirstIndex

        while (codeIndex < self.code.count) {
            if self.code[codeIndex] == "(" {
                codeIndex += 1

                guard let convertedFormulaData = self.ConvertFormula(codeFirstIndex: codeIndex) else {
                    return nil
                }

                argContents.append(convertedFormulaData.formulaData)

                codeIndex += convertedFormulaData.codeSize + 1

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
                guard let convertedFormulaData = self.ConvertFormula(codeFirstIndex: codeFirstIndex) else {
                    return nil
                }

                return ConvertedArgData(argData: [convertedFormulaData.formulaData], codeSize: convertedFormulaData.codeSize)
            }

            if code[codeIndex] == "~" {
                codeIndex += 1
            } else {
                if argContents.count >= 2 {
                    break
                } else {
                    guard let convertedFormulaData = self.ConvertFormula(codeFirstIndex: codeFirstIndex) else {
                        return nil
                    }

                    return ConvertedArgData(argData: [convertedFormulaData.formulaData], codeSize: convertedFormulaData.codeSize)
                }
            }
        }

        return ConvertedArgData(argData: argContents, codeSize: codeIndex - codeFirstIndex)
    }

    private func ConvertFormula(codeFirstIndex: Int) -> ConvertedFormulaData? {

        var argContents = [ArgContentType]()

        var codeIndex = codeFirstIndex

        while codeIndex < self.code.count {
            if self.variables.contains(self.code[codeIndex]) {
                argContents.append(.Variable(self.code[codeIndex]))

                codeIndex += 1

            } else if self.blockDataDictionary[self.code[codeIndex]]?.funcType == .ArgContent {
                guard let convertedFuncData = self.ConvertFunc(codeFirstIndex: codeIndex) else {
                    return nil
                }

                argContents.append(.Block(convertedFuncData.blockData))
                codeIndex += convertedFuncData.codeSize
            } else if self.code[codeIndex] == "(" {
                codeIndex += 1

                guard let convertedFormulaData = ConvertFormula(codeFirstIndex: codeIndex) else {
                    return nil
                }

                argContents.append(convertedFormulaData.formulaData)

                codeIndex += convertedFormulaData.codeSize + 1

            } else {
                var inputText = ""
                while codeIndex < self.code.count &&
                              !self.variables.contains(self.code[codeIndex]) &&
                              self.blockDataDictionary[self.code[codeIndex]]?.funcType != .ArgContent &&
                              self.code[codeIndex] != "(" && self.code[codeIndex] != ")" &&
                              !(codeFirstIndex < codeIndex && !self.operators.contains(self.code[codeIndex]) && !self.operators.contains(self.code[codeIndex - 1])) {
                    inputText += self.code[codeIndex]
                    codeIndex += 1
                }

                argContents.append(.Input(inputText))
            }

            if codeIndex >= self.code.count || self.code[codeIndex] == ")" || (!self.operators.contains(self.code[codeIndex]) && !self.operators.contains(self.code[codeIndex - 1])) {
                break
            }
        }

        if argContents.count == 1 {
            return ConvertedFormulaData(formulaData: argContents[0], codeSize: codeIndex - codeFirstIndex)
        } else {
            let thisBlockData = BlockData(funcType: .Block, funcName: "", contents: [
                BlockContentData(value: .Label("("), order: -1),
                BlockContentData(value: .Arg(argContents), order: 0),
                BlockContentData(value: .Label(")"), order: -1)
            ], indent: 0)

            return ConvertedFormulaData(formulaData: .Block(thisBlockData), codeSize: codeIndex - codeFirstIndex)
        }
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