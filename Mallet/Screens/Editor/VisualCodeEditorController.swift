//
//  VisualCodeEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VisualCodeEditorController: UIViewController, UIGestureRecognizerDelegate {

    private enum MovingBlockState {
        case notMoving
        case horizontal
        case vertical
    }

    private var movingBlockState: MovingBlockState = .notMoving

    private let codeStackView = UIStackView()

    private var blockPos = [CGFloat]()

    private var blocks = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        codeStackView.axis = .vertical
        codeStackView.distribution = .fill
        codeStackView.spacing = 5
        codeStackView.alignment = .leading

        self.view.addSubview(codeStackView)

        codeStackView.translatesAutoresizingMaskIntoConstraints = false

        codeStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        codeStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true

        let blockData = [
            BlockData(
                    contents: [BlockContentData(type: 0, value: "set"),
                               BlockContentData(type: 1, value: "var"),
                               BlockContentData(type: 0, value: "to"),
                               BlockContentData(type: 1, value: "0"), ],
                    indent: 0
            ),
            BlockData(
                    contents: [BlockContentData(type: 0, value: "repeat"),
                               BlockContentData(type: 1, value: "1024"), ],
                    indent: 0
            ),
            BlockData(
                    contents: [BlockContentData(type: 0, value: "set"),
                               BlockContentData(type: 1, value: "var"),
                               BlockContentData(type: 0, value: "to"),
                               BlockContentData(type: 1, value: "var+1"), ],
                    indent: 1
            ),
            BlockData(
                    contents: [BlockContentData(type: 0, value: "print"),
                               BlockContentData(type: 1, value: "var"), ],
                    indent: 0
            ),
            BlockData(
                    contents: [BlockContentData(type: 0, value: "print"),
                               BlockContentData(type: 1, value: "var*2"), ],
                    indent: 0
            ),
        ]

        for i in 0..<blockData.count {

            /*
            let stackViewInCodeStackView = UIStackView()

            stackViewInCodeStackView.axis = .horizontal
            stackViewInCodeStackView.translatesAutoresizingMaskIntoConstraints = false
            */

            let block = Block(blockData: blockData[i], index: i)

            block.translatesAutoresizingMaskIntoConstraints = false

            let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragBlock(_:)))
            pan.delegate = self
            block.addGestureRecognizer(pan)

            /*
            let center = block.superview?.convert(block.center, to: self.view)

            blockPos.append(center?.y ?? 0)

            blocks.append(block)
            */

            /*
            let blankView = UIView()
            let indentConstraint = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 30 * CGFloat(blockData[i].indent))
            block.indentConstraint = indentConstraint
            blankView.addConstraint(indentConstraint)

            stackViewInCodeStackView.addArrangedSubview(blankView)
            stackViewInCodeStackView.addArrangedSubview(block)

            codeStackView.addArrangedSubview(stackViewInCodeStackView)
            */

            codeStackView.addArrangedSubview(block)
        }
    }

    @objc private func dragBlock(_ sender: UIPanGestureRecognizer) {

        guard let senderView = sender.view else {
            return
        }

        let blockIndex = (senderView as! Block).index

        let move = sender.translation(in: self.view)
        sender.setTranslation(CGPoint.zero, in: self.view)

        if sender.state == .began {

            if abs(move.x) > 1 && abs(move.y) < 1 {
                movingBlockState = .horizontal

                let direction: Int!
                if move.x > 0 {
                    direction = 1
                } else {
                    direction = -1
                }

//                changeBlockIndent(blockIndex: blockIndex, direction: direction)

                (senderView as! Block).changeBlockIndent(direction: direction)

            } else {
                movingBlockState = .vertical

                let center = senderView.superview?.convert(senderView.center, to: self.view)

                codeStackView.removeArrangedSubview(senderView)
                self.view.addSubview(senderView)
                self.view.bringSubviewToFront(senderView)

                senderView.translatesAutoresizingMaskIntoConstraints = true

                senderView.center = center ?? CGPoint()

                floatBlock(index: blockIndex)
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

    private func floatBlock(index: Int) {
        let blankView = UIView()

        codeStackView.insertArrangedSubview(blankView, at: index)

        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func moveBlock(from: Int, to: Int) {
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

    private func dropBlock(index: Int, block: UIView) {
        let center = self.view.convert(block.center, to: codeStackView)

        block.center = center

        self.view.layoutIfNeeded()

        codeStackView.arrangedSubviews[index].removeFromSuperview()

        codeStackView.insertArrangedSubview(block, at: index)

        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func changeBlockIndent(blockIndex: Int, direction: Int) {
        print(direction)
    }
}
