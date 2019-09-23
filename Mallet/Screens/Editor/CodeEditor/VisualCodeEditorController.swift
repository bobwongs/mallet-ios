//
//  VisualCodeEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VisualCodeEditorController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, blockDelegate {
    enum MovingBlockState {
        case notMoving
        case horizontal
        case vertical
    }

    @IBOutlet weak var blockTableView: UITableView!

    static var codeArea: UIView = UIScrollView()

    let blockDefaultIndentSize: CGFloat = 10

    var movingBlockState: MovingBlockState = .notMoving

    let codeStackView = UIStackView()

    var blockViews = [Block]()

    var blocks: Dictionary<BlockType, BlockData> = [
        BlockType.SetUIText:
        BlockData(
                blockType: .SetUIText,
                funcType: .Func,
                funcName: "setUIText",
                contents: [BlockContentData(value: .Label("Set text of"), order: -1),
                           BlockContentData(value: .Arg([.Block(BlockData(blockType: .Variable, funcType: .Func, funcName: "label", contents: [BlockContentData(value: .Label("Label"), order: 0)], indent: 0))]), order: 0),
                           BlockContentData(value: .Label("to"), order: -1),
                           BlockContentData(value: .Arg([.Block(BlockData(blockType: .Variable, funcType: .Func, funcName: "count", contents: [BlockContentData(value: .Label("count"), order: 0)], indent: 0)), .Text("sec")]), order: 0),
                ],
                indent: 0),

        BlockType.IF:
        BlockData(
                blockType: .IF,
                funcType: .Bracket,
                funcName: "if",
                contents: [BlockContentData(value: .Label("If"), order: -1),
                           BlockContentData(value: .Arg([.Text("true")]), order: 0)],
                indent:
                0),

        BlockType.ELSE:
        BlockData(
                blockType: .ELSE,
                funcType: .Bracket,
                funcName: "else",
                contents: [BlockContentData(value: .Label("Else"), order: -1)],
                indent:
                0),

        BlockType.While:
        BlockData(
                blockType: .While,
                funcType: .Bracket,
                funcName: "while",
                contents: [BlockContentData(value: .Label("While"), order: -1),
                           BlockContentData(value: .Arg([.Text("true")]), order: 0)],
                indent:
                0),

        BlockType.Assign:
        BlockData(
                blockType: .Assign,
                funcType: .Assign,
                funcName: "",
                contents: [BlockContentData(value: .Label("Set"), order: -1),
                           BlockContentData(value: .Arg([.Block(BlockData(blockType: .Variable, funcType: .Func, funcName: "count", contents: [BlockContentData(value: .Label("count"), order: 0)], indent: 0))]), order: 0),
                           BlockContentData(value: .Label("to"), order: -1),
                           BlockContentData(value: .Arg([.Block(BlockData(blockType: .Variable, funcType: .Func, funcName: "count", contents: [BlockContentData(value: .Label("count"), order: 0)], indent: 0)), .Text("+1")]), order: 0),
                ],
                indent: 0
        ),

        BlockType.Sleep:
        BlockData(
                blockType: .Sleep,
                funcType: .Func,
                funcName: "sleep",
                contents: [BlockContentData(value: .Label("Wait"), order: -1),
                           BlockContentData(value: .Arg([.Text("1")]), order: 0),
                           BlockContentData(value: .Label("seconds"), order: -1),
                ],
                indent:
                0),

        /*
        BlockType.SetUIText:
        BlockData(
                blockType: .SetUIText,
                funcType: .Func,
                funcName: "setUIText",
                contents: [BlockContentData(type: .Label, value: "Set text of", order: -1),
                           BlockContentData(type: .InputSingleVariable, value: "Label1", order: 0),
                           BlockContentData(type: .Label, value: "to", order: -1),
                           BlockContentData(type: .InputAll, value: "512", order: 1)],
                indent:
                0),

        BlockType.Sleep:
        BlockData(
                blockType: .Sleep,
                funcType: .Func,
                funcName: "sleep",
                contents: [BlockContentData(type: .Label, value: "Wait", order: -1),
                           BlockContentData(type: .InputAll, value: "1", order: 0),
                           BlockContentData(type: .Label, value: "seconds", order: -1)],
                indent:
                0),

        BlockType.Assign:
        BlockData(
                blockType: .Assign,
                funcType: .Assign,
                funcName: "",
                contents: [BlockContentData(type: .Label, value: "Set", order: -1),
                           BlockContentData(type: .InputSingleVariable, value: "foo", order: 0),
                           BlockContentData(type: .Label, value: "to", order: -1),
                           BlockContentData(type: .InputAll, value: "128", order: 1)],
                indent:
                0),

        BlockType.Declare:
        BlockData(
                blockType: .Declare,
                funcType: .Declare,
                funcName: "",
                contents: [BlockContentData(type: .Label, value: "Declare", order: -1),
                           BlockContentData(type: .InputSingleVariable, value: "foo", order: 0),
                           BlockContentData(type: .Label, value: "(initial value:", order: -1),
                           BlockContentData(type: .InputAll, value: "128", order: 1),
                           BlockContentData(type: .Label, value: ")", order: -1)],
                indent:
                0),

        BlockType.Repeat:
        BlockData(
                blockType: .Repeat,
                funcType: .Bracket,
                funcName: "repeat",
                contents: [BlockContentData(type: .Label, value: "repeat", order: -1),
                           BlockContentData(type: .InputAll, value: "10", order: 0),
                           BlockContentData(type: .Label, value: "times", order: -1)],
                indent:
                0),

        BlockType.While:
        BlockData(
                blockType: .While,
                funcType: .Bracket,
                funcName: "while",
                contents: [BlockContentData(type: .Label, value: "while", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 0)],
                indent:
                0),

        BlockType.IF:
        BlockData(
                blockType: .IF,
                funcType: .Bracket,
                funcName: "if",
                contents: [BlockContentData(type: .Label, value: "if", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 0)],
                indent:
                0),

        BlockType.ELSE:
        BlockData(
                blockType: .ELSE,
                funcType: .Bracket,
                funcName: "else",
                contents: [BlockContentData(type: .Label, value: "else", order: -1)],
                indent:
                0),

        BlockType.AddToList:
        BlockData(
                blockType: .AddToList,
                funcType: .Func,
                funcName: "addToList",
                contents: [BlockContentData(type: .Label, value: "Add", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 1),
                           BlockContentData(type: .Label, value: "to", order: -1),
                           BlockContentData(type: .InputSingleVariable, value: "", order: 0)],
                indent:
                0),

        BlockType.ShowWebPage:
        BlockData(
                blockType: .ShowWebPage,
                funcType: .Func,
                funcName: "showWebPage",
                contents: [BlockContentData(type: .Label, value: "Show web page", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 1),
                           BlockContentData(type: .Label, value: "in", order: -1),
                           BlockContentData(type: .InputSingleVariable, value: "WebView", order: 0)],
                indent:
                0),

        BlockType.ShowInTableView:
        BlockData(
                blockType: .ShowInTableView,
                funcType: .Func,
                funcName: "showInTableView",
                contents: [BlockContentData(type: .Label, value: "Show", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 1),
                           BlockContentData(type: .Label, value: "in", order: -1),
                           BlockContentData(type: .InputSingleVariable, value: "TableView", order: 0)],
                indent:
                0),

        BlockType.CopyToClipboard:
        BlockData(
                blockType: .CopyToClipboard,
                funcType: .Func,
                funcName: "copyToClipBoard",
                contents: [BlockContentData(type: .Label, value: "Copy", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 1),
                           BlockContentData(type: .Label, value: "to clipBoard", order: -1)],
                indent:
                0),

        BlockType.Tweet:
        BlockData(
                blockType: .Tweet,
                funcType: .Func,
                funcName: "tweet",
                contents: [BlockContentData(type: .Label, value: "Tweet", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 1)],
                indent:
                0),

        BlockType.AddMemo:
        BlockData(
                blockType: .AddMemo,
                funcType: .Func,
                funcName: "addMemo",
                contents: [BlockContentData(type: .Label, value: "AddMemo", order: -1),
                           BlockContentData(type: .InputAll, value: "", order: 1)],
                indent:
                0),
                */
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        VisualCodeEditorController.codeArea = UIScrollView()

        VisualCodeEditorController.codeArea.backgroundColor = .vplBackground

        self.view.addSubview(VisualCodeEditorController.codeArea)
        VisualCodeEditorController.codeArea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            VisualCodeEditorController.codeArea.topAnchor.constraint(equalTo: self.view.topAnchor),
            VisualCodeEditorController.codeArea.bottomAnchor.constraint(equalTo: blockTableView.topAnchor),
            VisualCodeEditorController.codeArea.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            VisualCodeEditorController.codeArea.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])

        self.view.bringSubviewToFront(blockTableView)

        /*
        let backgroundColor = UIColor(red: 240, green: 240, blue: 240)
        VisualCodeEditorController.codeArea.backgroundColor = backgroundColor
        self.view.backgroundColor = backgroundColor
        */


        blockTableView.delegate = self
        blockTableView.dataSource = self
        blockTableView.layer.cornerRadius = 10
        blockTableView.layer.masksToBounds = true

        codeStackView.axis = .vertical
        codeStackView.distribution = .fill
        codeStackView.spacing = 5
        codeStackView.alignment = .leading

        VisualCodeEditorController.codeArea.addSubview(codeStackView)

        codeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeStackView.topAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.topAnchor, constant: 20),
            codeStackView.bottomAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.bottomAnchor),
            codeStackView.leftAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.leftAnchor, constant: blockDefaultIndentSize),
            codeStackView.rightAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.rightAnchor)
        ])

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BlockType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        let blockType = BlockType.allCases[indexPath.row]

        guard let blockData = blocks[blockType] else {
            return cell
        }

        let block = Block(blockData: blockData, index: 0, isOnTable: true)
        cell.addSubview(block)

        setBlockOnTable(block: block, cell: cell)

        return cell
    }

    func setBlockOnTable(block: UIView, cell: UIView) {
        block.translatesAutoresizingMaskIntoConstraints = false
        block.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: blockDefaultIndentSize).isActive = true
        block.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        block.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true

        block.isUserInteractionEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragBlock(_:)))
        pan.delegate = self
        block.addGestureRecognizer(pan)
    }

    @objc func dragBlock(_ sender: UIPanGestureRecognizer) {

        guard let blockView = sender.view as? Block else {
            fatalError()
        }

        let blockIndex = blockView.index
        let isOnTable = blockView.isOnTable

        let move = sender.translation(in: VisualCodeEditorController.codeArea)
        let velocity = sender.velocity(in: VisualCodeEditorController.codeArea)
        sender.setTranslation(CGPoint.zero, in: VisualCodeEditorController.codeArea)

        if sender.state == .began {
            if abs(velocity.x) > 100 && abs(velocity.y) < 100 && !isOnTable {
                movingBlockState = .horizontal

                let direction: Int!
                if velocity.x > 0 {
                    direction = 1
                } else {
                    direction = -1
                }

                changeIndent(movingBlockView: blockView, direction: direction)
            } else {
                if isOnTable {
                    guard let cell = blockView.superview else {
                        fatalError()
                    }

                    let blockType = blockView.blockType

                    guard let blockData = blocks[blockType] else {
                        fatalError()
                    }

                    let newBlockOnTable = Block(blockData: blockData, index: 0, isOnTable: true)

                    cell.addSubview(newBlockOnTable)

                    setBlockOnTable(block: newBlockOnTable, cell: cell)
                }

                movingBlockState = .vertical

                let center = blockView.superview?.convert(blockView.center, to: VisualCodeEditorController.codeArea)

                if isOnTable {
                    self.view.addSubview(blockView)
                    self.view.bringSubviewToFront(blockView)
                } else {
                    VisualCodeEditorController.codeArea.addSubview(blockView)
                    VisualCodeEditorController.codeArea.bringSubviewToFront(blockView)
                }

                blockView.translatesAutoresizingMaskIntoConstraints = true

                blockView.center = center ?? CGPoint()

                if (isOnTable) {
                    blockView.index = codeStackView.arrangedSubviews.count
                    blockView.isOnTable = false
                    blockView.delegate = self

                    blockViews.append(blockView)
                    blockViews.append(blockView)

                    addBlock()

                } else {
                    floatBlock(blockView: blockView, index: blockIndex)
                }
            }

            return
        }

        if sender.state == .ended {
            if movingBlockState == .vertical {
                dropBlock(index: blockIndex, block: blockView)

                if blockView.index < codeStackView.arrangedSubviews.count - 1 {
                    guard let bottomBlockIndent = (codeStackView.arrangedSubviews[blockView.index + 1] as? Block)?.indent else {
                        fatalError()
                    }

                    blockView.changeBlockIndent(direction: bottomBlockIndent - blockView.indent)
                }
            }

            fixIndent()

            movingBlockState = .notMoving

            return
        }

        if movingBlockState == .vertical {

            sender.view?.center.y += move.y

            self.view.layoutIfNeeded()

            let centerY = blockView.superview?.convert(blockView.center, to: codeStackView).y ?? 0

            var nearestIndex = -1
            var minDiff: CGFloat = 10000000
            for i in 0..<codeStackView.arrangedSubviews.count {

                let diff = abs(centerY - codeStackView.arrangedSubviews[i].center.y)

                if diff < minDiff {
                    nearestIndex = i

                    minDiff = diff
                }
            }

            if nearestIndex != blockIndex {
                blockView.index = nearestIndex

                moveBlock(blockView: blockView, from: blockIndex, to: nearestIndex)
            }
        }
    }

    func addBlock() {
        HapticFeedback.blockFeedback()

        let blankView = UIView()
        codeStackView.addArrangedSubview(blankView)

        blankView.translatesAutoresizingMaskIntoConstraints = false

        self.view.layoutIfNeeded()
    }

    func floatBlock(blockView: UIView, index: Int) {
        HapticFeedback.blockFeedback()

        let blankView = UIView()

        codeStackView.insertArrangedSubview(blankView, at: index)

        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.heightAnchor.constraint(equalToConstant: blockView.frame.height).isActive = true
    }

    func moveBlock(blockView: UIView, from: Int, to: Int) {
        HapticFeedback.selectionFeedback()

        let fromBlankView = codeStackView.arrangedSubviews[from]
        let toBlankView = UIView()

        VisualCodeEditorController.codeArea.addSubview(toBlankView)

        let fromViewHeight = NSLayoutConstraint(item: fromBlankView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: blockView.frame.height)
        let toViewHeight = NSLayoutConstraint(item: toBlankView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0)

        fromBlankView.removeConstraints(fromBlankView.constraints)
        fromBlankView.addConstraint(fromViewHeight)

        toBlankView.translatesAutoresizingMaskIntoConstraints = false
        toBlankView.addConstraint(toViewHeight)

        if to < from {
            codeStackView.insertArrangedSubview(toBlankView, at: to)
        } else {
            codeStackView.insertArrangedSubview(toBlankView, at: to + 1)
        }

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        fromViewHeight.constant = 0
        toViewHeight.constant = blockView.frame.height

        UIView.animate(withDuration: 0.2, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        fromBlankView.removeFromSuperview()

        (codeStackView.arrangedSubviews[from] as! Block).index = from
    }

    func dropBlock(index: Int, block: UIView) {
        HapticFeedback.blockFeedback()

        let center = VisualCodeEditorController.codeArea.convert(block.center, to: codeStackView)

        block.center = center

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        codeStackView.arrangedSubviews[index].removeFromSuperview()

        codeStackView.insertArrangedSubview(block, at: index)

        UIView.animate(withDuration: 0.2, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })
    }

    func deleteBlock(index: Int) {
        HapticFeedback.blockFeedback()

        let blockView = codeStackView.arrangedSubviews[index]

        floatBlock(blockView: blockView, index: index)

        blockView.removeFromSuperview()

        let blankView = codeStackView.arrangedSubviews[index]

        let blankViewHeightConstraint = NSLayoutConstraint(item: blankView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: blockView.frame.height)

        blankView.removeConstraints(blankView.constraints)
        blankView.addConstraint(blankViewHeightConstraint)

        codeStackView.insertArrangedSubview(blankView, at: index)

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        blankViewHeightConstraint.constant = 0

        UIView.animate(withDuration: 0.2, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        blankView.removeFromSuperview()

        for blockIndex in index..<codeStackView.arrangedSubviews.count {
            guard let blockView = codeStackView.arrangedSubviews[blockIndex] as? Block else {
                fatalError()
            }

            blockView.index -= 1
        }
    }

    func changeIndent(movingBlockView: Block, direction: Int) {
        let blockIndex = movingBlockView.index

        if blockIndex == 0 {
            return
        }

        let currentIndent = movingBlockView.indent

        let nextIndent: Int!

        if direction > 0 {
            nextIndent = currentIndent + 1

            var index = blockIndex - 1

            while index >= 0 {

                guard let blockView = codeStackView.arrangedSubviews[index] as? Block else {
                    fatalError()
                }

                let indent: Int!

                if blockView.isBracket {
                    indent = blockView.indent + 1
                } else {
                    indent = blockView.indent
                }

                if indent == nextIndent {
                    break
                }

                if indent < nextIndent {
                    return
                }

                index -= 1
            }

            movingBlockView.changeBlockIndent(direction: 1)

        } else {
            if currentIndent == 0 {
                return
            }

            movingBlockView.changeBlockIndent(direction: -1)

            var index = blockIndex + 1

            while index < codeStackView.arrangedSubviews.count {
                guard let blockView = codeStackView.arrangedSubviews[index] as? Block else {
                    fatalError()
                }

                if blockView.indent == currentIndent {
                    return
                }

                blockView.changeBlockIndent(direction: -1)

                index += 1
            }
        }

        HapticFeedback.blockFeedback()
    }

    func fixIndent() {
        var maxIndent = 0

        for block in codeStackView.arrangedSubviews {
            guard let blockView = block as? Block else {
                fatalError()
            }

            if maxIndent < blockView.indent {
                blockView.changeBlockIndent(direction: maxIndent - blockView.indent)
            }

            if maxIndent > blockView.indent {
                maxIndent = blockView.indent
            }

            if blockView.isBracket {
                maxIndent += 1
            }
        }
    }

    func vplToCode() -> String {
        return vplToCode(startIndex: 0).0
    }

    func vplToCode(startIndex: Int) -> (String, Int) {

        if startIndex < 0 || codeStackView.arrangedSubviews.count <= startIndex {
            return ("", 0)
        }

        guard let firstIndent = (codeStackView.arrangedSubviews[startIndex] as? Block)?.indent else {
            fatalError()
        }

        var code = ""

        var lastIndex = codeStackView.arrangedSubviews.count - 1

        var index = startIndex
        while index < codeStackView.arrangedSubviews.count {

            guard let blockView = codeStackView.arrangedSubviews[index] as? Block else {
                fatalError()
            }

            if blockView.indent < firstIndent {
                lastIndex = index - 1
                break
            }

            let blockType = blockView.blockType

            guard let blockData = blocks[blockType] else {
                fatalError()
            }

            let args = blockView.args()

            switch blockData.funcType {
            case .Func:
                code += "\(blockData.funcName)("

                /*
                TODO:
                for argIndex in 0..<args.count {
                    switch args[argIndex].type {
                    case .InputAll:
                        code += "\(args[argIndex].content)"
                    case .InputSingleVariable:
                        code += "\(args[argIndex].content)"
                    default:
                        break
                    }

                    if argIndex != (args.count - 1) {
                        code += ","
                    }
                }
                */

                code += ")\n"

            case .Assign:
                if args.count != 2 {
                    continue
                }

                code += "\(args[0].content) = \(args[1].content)\n"

            case .Declare:
                if args.count != 2 {
                    continue
                }

                code += "var \(args[0].content) = \(args[1].content)\n"

            case .Bracket:
                if args.count != 1 {
                    continue
                }

                let codeWithIndex: (String, Int)!

                if index == codeStackView.arrangedSubviews.count - 1 ||
                           (codeStackView.arrangedSubviews[index + 1] as? Block)?.indent == blockView.indent {
                    codeWithIndex = ("", index)
                } else {
                    codeWithIndex = vplToCode(startIndex: index + 1)
                }

                code += """
                        \(blockData.funcName) (\(args[0].content))
                        {
                        \(codeWithIndex.0)
                                }
                        """

                index = codeWithIndex.1

            }

            index += 1

        }

        print(code)

        return (code, lastIndex)
    }

}

protocol blockDelegate: class {
    func deleteBlock(index: Int)
}
