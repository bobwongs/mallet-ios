//
//  VisualCodeEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VisualCodeEditorController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    enum MovingBlockState {
        case notMoving
        case horizontal
        case vertical
    }

    @IBOutlet weak var blockTableView: UITableView!

    let blockDefaultIndentSize: CGFloat = 20

    var movingBlockState: MovingBlockState = .notMoving

    let codeStackView = UIStackView()

    var blockViews = [Block]()

    var blocks: Dictionary<BlockType, BlockData> = [
        BlockType.Print:
        BlockData(
                blockType: .Print,
                funcType: .Func,
                funcName: "print",
                contents: [BlockContentData(type: .Label, value: "Print", order: -1),
                           BlockContentData(type: .InputAll, value: "256", order: 0)],
                indent: 0),

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
                funcName: "",
                contents: [BlockContentData(type: .Label, value: "repeat", order: -1),
                           BlockContentData(type: .InputAll, value: "10", order: 0),
                           BlockContentData(type: .Label, value: "times", order: -1)],
                indent:
                0),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)

        blockTableView.delegate = self
        blockTableView.dataSource = self

        codeStackView.axis = .vertical
        codeStackView.distribution = .fill
        codeStackView.spacing = 5
        codeStackView.alignment = .leading

        self.view.addSubview(codeStackView)

        codeStackView.translatesAutoresizingMaskIntoConstraints = false

        codeStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        codeStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: blockDefaultIndentSize).isActive = true


        /*
        for i in 0..<5 {

            let block = Block(blockData: blocks[i % (blocks.count)], index: i, isOnTable: false)

            block.translatesAutoresizingMaskIntoConstraints = false

            let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragBlock(_:)))
            pan.delegate = self
            block.addGestureRecognizer(pan)

            codeStackView.addArrangedSubview(block)
        }
        */
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

        guard let senderView = sender.view else {
            return
        }

        let blockView = senderView as! Block

        let blockIndex = blockView.index
        let isOnTable = blockView.isOnTable

        let move = sender.translation(in: self.view)
        sender.setTranslation(CGPoint.zero, in: self.view)

        if sender.state == .began {

            if abs(move.x) > 0.3 && abs(move.y) < 1 && !isOnTable {
                movingBlockState = .horizontal

                let direction: Int!
                if move.x > 0 {
                    direction = 1
                } else {
                    direction = -1
                }

                blockView.changeBlockIndent(direction: direction)

            } else {
                if (isOnTable) {
                    guard let cell = senderView.superview else {
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

                let center = senderView.superview?.convert(senderView.center, to: self.view)

                self.view.addSubview(senderView)
                self.view.bringSubviewToFront(senderView)

                senderView.translatesAutoresizingMaskIntoConstraints = true

                senderView.center = center ?? CGPoint()

                if (isOnTable) {
                    blockView.index = codeStackView.arrangedSubviews.count
                    blockView.isOnTable = false
                    addBlock()

                } else {
                    floatBlock(index: blockIndex)
                }
            }

            return
        }

        if sender.state == .ended {

            if movingBlockState == .vertical {
                dropBlock(index: blockIndex, block: senderView)
            } else {
                /*
                dropBlock(index: blockIndex, block: senderView)
                */
            }

            movingBlockState = .notMoving

            return
        }

        if movingBlockState == .vertical {

            sender.view?.center.y += move.y


            let centerY = senderView.superview?.convert(senderView.center, to: codeStackView).y ?? 0

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
                (senderView as! Block).index = nearestIndex

                moveBlock(from: blockIndex, to: nearestIndex)
            }
        } else {

            /*
            senderView.center.x += move.x

            sender.setTranslation(CGPoint.zero, in: self.view)
            */

        }
    }

    func addBlock() {
        let blankView = UIView()
        codeStackView.addArrangedSubview(blankView)

        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    func floatBlock(index: Int) {
        let blankView = UIView()

        codeStackView.insertArrangedSubview(blankView, at: index)

        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    func moveBlock(from: Int, to: Int) {
        let fromBlankView = codeStackView.arrangedSubviews[from]
        let toBlankView = UIView()

        self.view.addSubview(toBlankView)

        let fromViewHeight = NSLayoutConstraint(item: fromBlankView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 44)
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

        self.view.layoutIfNeeded()

        fromViewHeight.constant = 0
        toViewHeight.constant = 44

        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })

        fromBlankView.removeFromSuperview()

        (codeStackView.arrangedSubviews[from] as! Block).index = from
    }

    func dropBlock(index: Int, block: UIView) {
        let center = self.view.convert(block.center, to: codeStackView)

        block.center = center

        self.view.layoutIfNeeded()

        codeStackView.arrangedSubviews[index].removeFromSuperview()

        codeStackView.insertArrangedSubview(block, at: index)

        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })

        vplToCode()
    }

    func vplToCode() -> String {
        var code = ""

        for view in codeStackView.arrangedSubviews {
            guard let blockView = view as? Block else {
                fatalError()
            }

            let blockType = blockView.blockType

            guard let blockData = blocks[blockType] else {
                fatalError()
            }

            let args = blockView.args()

            switch blockData.funcType {
            case .Func:
                code += "\(blockData.funcName)("

                for argIndex in 0..<args.count {
                    switch args[argIndex].type {
                    case .InputAll:
                        code += "\"\(args[argIndex].content)\""
                    case .InputSingleVariable:
                        code += "\(args[argIndex].content)"
                    default:
                        break
                    }

                    if argIndex != (args.count - 1) {
                        code += ","
                    }
                }

                code += ")\n"

            case .Assign:
                if args.count != 2 {
                    continue
                }

                code += "\(args[0].content) = \"\(args[1].content)\""

            case .Declare:
                if args.count != 2 {
                    continue
                }

                code += "var \(args[0].content) = \"\(args[1].content)\""

            case .Bracket:

                //TODO:

                break

            }

        }

        print(code)

        return code
    }
}
