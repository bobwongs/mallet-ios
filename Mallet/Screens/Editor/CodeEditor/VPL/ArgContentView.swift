//
//  Argself.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/04.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ArgContent: UIView, UIGestureRecognizerDelegate {

    public var delegate: ArgContentViewDelegate?

    private var index = -1

    private var currentIndex = -1

    private var stackView: UIStackView?

    private var currentStackView: UIStackView?

    private var value: ArgContentType

    init(argContentValue: ArgContentType, stackView: UIStackView, index: Int) {

        self.stackView = stackView

        self.value = argContentValue

        super.init(frame: CGRect())

        self.isUserInteractionEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)

        setContentIndex(index: index)

        switch self.value {
        case .Text(let text):

            break

        case .Block(let blockData):

            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func getValue() -> String {
        switch self.value {
        case .Text(let text):
            return text

        case .Block(let blockData):
            return ""

            break
        }
    }

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {

        if sender.state == .began {
            self.translatesAutoresizingMaskIntoConstraints = true
            if self.index != -1 {
                floatContent()
            }
        }

        if sender.state == .ended {
            if self.index != -1 {
                insertContent()
            }

            return
        }

        let move = sender.translation(in: self)
        sender.setTranslation(CGPoint.zero, in: self)

        self.center.x += move.x
        self.center.y += move.y

        self.stackView = delegate?.findArgViewStack(argContentView: self)

        if self.stackView == nil {
            self.index = -1
        }

        if self.currentIndex != -1 && self.index == -1 {
            removeBlankView()

            self.currentIndex = -1
            self.currentStackView = self.stackView

            return
        }

        guard let stackView = self.stackView else {
            return
        }

        var minDis = stackView.bounds.width * 100000
        var minIndex = -1
        var index = 0

        if stackView.arrangedSubviews.count == 0 {
            minIndex = 0
        } else {
            for contentIndex in 0..<stackView.arrangedSubviews.count {
                let contentInStackView = stackView.arrangedSubviews[contentIndex]

                let contentFrame = contentInStackView.superview!.convert(contentInStackView.frame, to: VisualCodeEditorController.codeArea)

                if contentIndex == 0 {
                    let dis: CGFloat!
                    if 0 < stackView.arrangedSubviews.count &&
                               !(stackView.arrangedSubviews[0] is ArgContent) {
                        dis = min(
                                abs((contentFrame.minX + ArgView.spaceBetweenContents / 2) - self.center.x)
                                ,
                                abs((contentFrame.minX + ArgView.spaceBetweenContents / 2 + stackView.arrangedSubviews[0].frame.width + ArgView.spaceBetweenContents) - self.center.x))
                    } else {
                        dis = abs((contentFrame.minX - ArgView.spaceBetweenContents / 2) - self.center.x)
                    }

                    if minDis > dis {
                        minDis = dis
                        minIndex = 0
                    }

                    index += 1
                }

                if !(contentInStackView is ArgContent) {
                    continue
                }

                let dis: CGFloat!

                if contentIndex < stackView.arrangedSubviews.count - 1 &&
                           !(stackView.arrangedSubviews[contentIndex + 1] is ArgContent) {
                    dis = min(
                            abs((contentFrame.maxX + ArgView.spaceBetweenContents / 2) - self.center.x)
                            ,
                            abs((contentFrame.maxX + ArgView.spaceBetweenContents / 2 + stackView.arrangedSubviews[contentIndex + 1].frame.width + ArgView.spaceBetweenContents) - self.center.x)
                    )
                } else {
                    dis = abs((contentFrame.maxX + ArgView.spaceBetweenContents / 2) - self.center.x)
                }

                if minDis > dis {
                    minDis = dis
                    minIndex = index
                } else {
                    break
                }

                index += 1
            }
        }


        self.index = minIndex
        if self.currentIndex == -1 {
            insertBlankView()
        } else {
            moveBlankView(from: self.currentIndex, to: self.index)
        }

        self.currentStackView = self.stackView
        self.currentIndex = self.index
    }

    func insertContent() {
        guard let stackView = self.stackView else {
            return
        }

        HapticFeedback.blockFeedback()

        let blankView = stackView.arrangedSubviews[index]

        let center = VisualCodeEditorController.codeArea.convert(self.center, to: stackView)

        self.center = center

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        stackView.removeArrangedSubview(blankView)

        blankView.removeFromSuperview()

        stackView.insertArrangedSubview(self, at: self.index)

        UIView.animate(withDuration: 0.1, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        for contentIndex in (self.index + 1)..<stackView.arrangedSubviews.count {
            guard  let contentInStackView = stackView.arrangedSubviews[contentIndex] as? ArgContent else {
                fatalError()
            }

            contentInStackView.setContentIndex(index: contentIndex)
        }
    }

    func floatContent() {
        guard let stackView = self.stackView else {
            return
        }

        HapticFeedback.blockFeedback()

        let center = self.superview!.convert(self.center, to: VisualCodeEditorController.codeArea)

        stackView.removeArrangedSubview(self)
        VisualCodeEditorController.codeArea.addSubview(self)

        self.center = center

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: self.index)
        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.widthAnchor.constraint(equalTo: blankView.widthAnchor).isActive = true

        for contentIndex in (self.index + 1)..<stackView.arrangedSubviews.count {
            guard  let contentInStackView = stackView.arrangedSubviews[contentIndex] as? ArgContent else {
                fatalError()
            }

            contentInStackView.setContentIndex(index: contentIndex - 1)
        }
    }

    func insertBlankView() {
        guard let stackView = self.stackView else {
            return
        }

        HapticFeedback.selectionFeedback()

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: self.index)
        blankView.translatesAutoresizingMaskIntoConstraints = false

        let blankViewWidth = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0)
        blankView.addConstraint(blankViewWidth)

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        blankViewWidth.constant = self.frame.width

        UIView.animate(withDuration: 0.1, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })
    }

    func moveBlankView(from: Int, to: Int) {
        guard let stackView = self.stackView else {
            return
        }

        if from != to {
            HapticFeedback.selectionFeedback()
        }

        let fromBlankView = stackView.arrangedSubviews[from]
        fromBlankView.removeConstraints(fromBlankView.constraints)
        let fromBlankViewWidth = NSLayoutConstraint(item: fromBlankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.frame.width)
        fromBlankView.addConstraint(fromBlankViewWidth)
        fromBlankView.heightAnchor.constraint(equalToConstant: 0).isActive = true

        let toBlankView = UIView()
        if to < from {
            stackView.insertArrangedSubview(toBlankView, at: to)
        } else {
            stackView.insertArrangedSubview(toBlankView, at: to + 1)
        }
        toBlankView.translatesAutoresizingMaskIntoConstraints = false
        let toBlankViewWidth = NSLayoutConstraint(item: toBlankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0)
        toBlankView.addConstraint(toBlankViewWidth)

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        fromBlankView.removeConstraints(fromBlankView.constraints)
        fromBlankViewWidth.constant = 0
        fromBlankView.addConstraint(fromBlankViewWidth)
        toBlankViewWidth.constant = self.frame.width

        UIView.animate(withDuration: 0.1, animations:
        {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        fromBlankView.removeFromSuperview()
    }

    func removeBlankView() {
        guard let stackView = self.currentStackView else {
            return
        }

        HapticFeedback.selectionFeedback()

        let blankView = stackView.arrangedSubviews[self.currentIndex]

        blankView.removeConstraints(blankView.constraints)

        let blankViewWidth = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.frame.width)
        blankView.addConstraint(blankViewWidth)

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        blankViewWidth.constant = 0

        UIView.animate(withDuration: 0.1, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        stackView.removeArrangedSubview(blankView)
        blankView.removeFromSuperview()
    }

    public func setContentIndex(index: Int) {
        self.index = index
        self.currentIndex = index
    }
}

class ArgText: ArgContent, UITextFieldDelegate {
    init(value: String, stackView: UIStackView, index: Int, visualCodeEditorController: VisualCodeEditorController) {

        super.init(argContentValue: .Text(value), stackView: stackView, index: index)

        self.delegate = visualCodeEditorController

        self.translatesAutoresizingMaskIntoConstraints = false
        /*
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 3
        */


        if #available(iOS 13, *) {
            self.backgroundColor = .placeholderText
        } else {
            self.backgroundColor = .white
        }
        self.layer.cornerRadius = 5

        let textField = UITextField()
        textField.delegate = self
        /*
        if #available(iOS 13, *) {
            textField.backgroundColor = .pla //.systemBackground
        } else {
            textField.backgroundColor = .white
        }
        */
        /*
        textField.layer.borderWidth = 2
        if #available(iOS 13, *) {
            textField.layer.borderColor = UIColor.separator.cgColor
        } else {
            textField.layer.borderColor = UIColor.white.cgColor
        }
        */

        let padding: CGFloat = 5

        textField.layer.cornerRadius = 3
        textField.text = value
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.sizeToFit()
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    textField.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
                    textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
                    textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
                    textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding)
                ]
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

class ArgBlock: ArgContent {

    private let blockView: BlockView!

    init(blockData: BlockData, stackView: UIStackView, index: Int, visualCodeEditorController: VisualCodeEditorController) {
        self.blockView = BlockView(blockData: blockData, visualCodeEditorController: visualCodeEditorController)

        super.init(argContentValue: .Block(blockData), stackView: stackView, index: index)

        self.delegate = visualCodeEditorController

        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    blockView.topAnchor.constraint(equalTo: self.topAnchor),
                    blockView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    blockView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    blockView.rightAnchor.constraint(equalTo: self.rightAnchor)
                ]
        )

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public func findArgViewStack(argContentView: ArgContent) -> UIStackView? {
        return self.blockView.findArgViewStack(argContentView: argContentView)
    }
}

protocol ArgContentViewDelegate {
    func findArgViewStack(argContentView: ArgContent) -> UIStackView?
}