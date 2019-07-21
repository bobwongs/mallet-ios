//
//  VisualCodeEditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/07/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VisualCodeEditorController: UIViewController, UIGestureRecognizerDelegate {

    let codeStackView = UIStackView()

    var blockPos = [CGFloat]()

    var blocks = [UIView]()

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

        for i in 0..<10 {

            let blockData =
                    BlockData(
                            contents: [BlockContentData(type: 0, value: "print"),
                                       BlockContentData(type: 1, value: "1024"), ],
                            indent: i % 2
                    )

            let block = Block(blockData: blockData, index: i)

            block.translatesAutoresizingMaskIntoConstraints = false

            codeStackView.addArrangedSubview(block)

            let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
            pan.delegate = self
            block.addGestureRecognizer(pan)

            let center = block.superview?.convert(block.center, to: self.view)

            blockPos.append(center?.y ?? 0)

            blocks.append(block)

        }
    }

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {

        guard let senderView = sender.view else {
            return
        }

        let blockIndex = (senderView as! Block).index

        if sender.state == .began {

            let center = senderView.superview?.convert(senderView.center, to: self.view)

            codeStackView.removeArrangedSubview(senderView)
            self.view.addSubview(senderView)
            self.view.bringSubviewToFront(senderView)

            senderView.translatesAutoresizingMaskIntoConstraints = true

            senderView.center = center ?? CGPoint()

            floatBlock(index: blockIndex)

            return
        }

        if sender.state == .ended {
            dropBlock(index: blockIndex, block: senderView)

            return

        }

        let move = sender.translation(in: self.view)
        sender.view?.center.y += move.y

        sender.setTranslation(CGPoint.zero, in: self.view)

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
    }
}
