//
//  VisualCodeEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VisualCodeEditorController: UIViewController, UIGestureRecognizerDelegate, blockDelegate, ArgContentViewDelegate {
    enum MovingBlockState {
        case notMoving
        case horizontal
        case vertical
    }

    static var codeArea: UIView = UIScrollView()

    static let blockDefaultIndentSize: CGFloat = 10

    var movingBlockState: MovingBlockState = .notMoving

    let codeStackView = UIStackView()

    var blockViews = [Block]()

    var vplBlockTable: VPLSelectionView!
    var vplBlockTableBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        VisualCodeEditorController.codeArea = UIScrollView()

        VisualCodeEditorController.codeArea.backgroundColor = .vplBackground

        self.view.addSubview(VisualCodeEditorController.codeArea)
        VisualCodeEditorController.codeArea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            VisualCodeEditorController.codeArea.topAnchor.constraint(equalTo: self.view.topAnchor),
            VisualCodeEditorController.codeArea.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            VisualCodeEditorController.codeArea.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            VisualCodeEditorController.codeArea.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])

        codeStackView.axis = .vertical
        codeStackView.distribution = .fill
        codeStackView.spacing = 5
        codeStackView.alignment = .leading

        VisualCodeEditorController.codeArea.addSubview(codeStackView)

        codeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeStackView.topAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.topAnchor, constant: 20),
            codeStackView.bottomAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.bottomAnchor),
            codeStackView.leftAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.leftAnchor, constant: VisualCodeEditorController.blockDefaultIndentSize),
            codeStackView.rightAnchor.constraint(equalTo: VisualCodeEditorController.codeArea.rightAnchor)
        ])

        vplBlockTable = VPLSelectionView(visualCodeEditorController: self)
        self.view.addSubview(vplBlockTable)

        vplBlockTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    vplBlockTable.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                    //vplBlockTable.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -vplBlockTable.titleBarHeight),
                    vplBlockTable.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                    vplBlockTable.heightAnchor.constraint(equalToConstant: vplBlockTable.height)
                ]
        )

        vplBlockTableBottomConstraint = NSLayoutConstraint(item: vplBlockTable!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -vplBlockTable.titleBarHeight)
        vplBlockTableBottomConstraint.isActive = true
    }

    func setBlockOnTable(block: UIView, cell: UIView) {
        block.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    block.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: VisualCodeEditorController.blockDefaultIndentSize),
                    block.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10),
                    block.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10),
                ]
        )

        block.isUserInteractionEnabled = true

        self.addBlockGesture(block: block)
    }

    private func addBlockGesture(block: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.dragBlock(_:)))
        pan.delegate = self
        block.addGestureRecognizer(pan)
    }

    func generateNewArgContent(content: ArgContent) {
        var newContent: UIView?

        if content is ArgText {
            newContent = ArgText(value: "", stackView: nil, index: -1, visualCodeEditorController: self, isOnTable: true)

        } else if content is ArgInput {
            newContent = ArgInput(value: "", stackView: nil, index: -1, visualCodeEditorController: self, isOnTable: true)

        } else if content is ArgVariable {
            newContent = ArgVariable(varName: (content as! ArgVariable).varName, stackView: nil, index: -1, visualCodeEditorController: self, isOnTable: true)

        } else if content is ArgBlock {
            newContent = ArgBlock(blockData: (content as! ArgBlock).initialBlockData, stackView: nil, index: -1, visualCodeEditorController: self, isOnTable: true)

        }

        guard let argContentView = newContent as? ArgContent else {
            return
        }

        if let cell = content.cellInTableView {
            argContentView.setArgContentOnTable(cellInTableView: cell, superView: self.view)
        } else if let cell = content.cellInStack {
            argContentView.setArgContentOnTable(cellInStackView: cell, superView: self.view)
        }
    }

    func generateBlocks(blockData: [BlockData]) {
        for blockView in self.codeStackView.arrangedSubviews {
            self.codeStackView.removeArrangedSubview(blockView)
            blockView.removeFromSuperview()
        }

        for (index, block) in blockData.enumerated() {
            let blockView = Block(blockData: block, index: index, isOnTable: false, visualCodeEditorController: self)

            self.addBlockGesture(block: blockView)

            self.codeStackView.addArrangedSubview(blockView)
        }
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

                    let blockData = blockView.initialBlockData

                    let newBlockOnTable = Block(blockData: blockData, index: 0, isOnTable: true, visualCodeEditorController: self)

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

    func findArgViewStack(argContentView: ArgContent) -> UIStackView? {
        let center = argContentView.superview!.convert(argContentView.center, to: self.codeStackView)

        for blockView in codeStackView.arrangedSubviews {
            guard let block = blockView as? Block else {
                continue
            }

            if block.frame.contains(center) {
                return block.findArgViewStack(argContentView: argContentView)
            }
        }

        return nil
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

            code += blockView.getCodeStr()

            if blockView.isBracket {
                let codeWithIndex: (String, Int)!

                if index == codeStackView.arrangedSubviews.count - 1 ||
                           (codeStackView.arrangedSubviews[index + 1] as? Block)?.indent == blockView.indent {
                    codeWithIndex = ("", index)
                } else {
                    codeWithIndex = vplToCode(startIndex: index + 1)
                }

                code += """
                        {
                        \(codeWithIndex.0)}

                        """

                index = codeWithIndex.1
            }

            index += 1
        }

        print(code)

        return (code, lastIndex)
    }

    func generateBlockTableModal() {

    }

    func showVPLBlockTable() {
        self.view.layoutIfNeeded()

        vplBlockTableBottomConstraint.constant = -vplBlockTable.height

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func hideVPLBlockTable() {
        self.view.layoutIfNeeded()

        vplBlockTableBottomConstraint.constant = -vplBlockTable.titleBarHeight

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

}

protocol blockDelegate: class {
    func deleteBlock(index: Int)
}
