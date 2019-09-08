//
//  ArgContent.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/04.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class ArgContent: UIView, UIGestureRecognizerDelegate {

    let stackView: UIStackView!

    var index = -1

    private var value: ArgContentType

    init(argContentValue: ArgContentType, stackView: UIStackView) {

        self.stackView = stackView

        self.value = argContentValue

        super.init(frame: CGRect())

        self.isUserInteractionEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragUI(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)

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
        guard let content = sender.view as? ArgContent else {
            print("This is not a variable")
            return
        }

        if sender.state == .began {
            content.translatesAutoresizingMaskIntoConstraints = true

            /*
            if content.superview == variableStackView {
                let center = content.superview?.convert(content.center, to: self.view)
                self.view.addSubview(content)
                content.center = center ?? CGPoint()

                let ArgContent = ArgContent()
                variableStackView.insertArrangedSubview(ArgContent, at: 0)
                setContent(ui: ArgContent)
            } else
            */
            if true {
                if content.index != -1 {
                    self.floatContent(content: content, index: content.index)
                }
            }
        }

        if sender.state == .ended {
            if content.index != -1 {
                insertContent(content: content, index: content.index)
            }

            return
        }

        let move = sender.translation(in: self)
        sender.setTranslation(CGPoint.zero, in: self)

        sender.view?.center.x += move.x
        sender.view?.center.y += move.y

        let stackViewFrame = stackView.superview!.convert(stackView.frame, to: VisualCodeEditorController.codeArea)

        if content.frame.origin.y + content.frame.height < stackViewFrame.origin.y ||
                   stackViewFrame.origin.y + stackViewFrame.height < content.frame.origin.y ||
                   content.frame.origin.x + content.frame.width < stackViewFrame.origin.x ||
                   stackViewFrame.origin.x + stackViewFrame.width < content.frame.origin.x {

            if content.index != -1 {
                removeBlankView(content: content, index: content.index)
                content.index = -1
            }

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
                                abs((contentFrame.minX + ArgView.spaceBetweenContents / 2) - content.center.x)
                                ,
                                abs((contentFrame.minX + ArgView.spaceBetweenContents / 2 + stackView.arrangedSubviews[0].frame.width + ArgView.spaceBetweenContents) - content.center.x))
                    } else {
                        dis = abs((contentFrame.minX - ArgView.spaceBetweenContents / 2) - content.center.x)
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
                            abs((contentFrame.maxX + ArgView.spaceBetweenContents / 2) - content.center.x)
                            ,
                            abs((contentFrame.maxX + ArgView.spaceBetweenContents / 2 + stackView.arrangedSubviews[contentIndex + 1].frame.width + ArgView.spaceBetweenContents) - content.center.x)
                    )
                } else {
                    dis = abs((contentFrame.maxX + ArgView.spaceBetweenContents / 2) - content.center.x)
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

        /*
        if stackView.arrangedSubviews.count <= minIndex {
            return
        }
        */

        if content.index == -1 {
            insertBlankView(content: content, index: minIndex)
        } else {
            moveBlankView(content: content, from: content.index, to: minIndex)
        }

        content.index = minIndex
    }

    func insertContent(content: ArgContent, index: Int) {
        let blankView = stackView.arrangedSubviews[index]

        let center = VisualCodeEditorController.codeArea.convert(content.center, to: stackView)

        content.center = center

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        stackView.removeArrangedSubview(blankView)

        stackView.insertArrangedSubview(content, at: index)

        UIView.animate(withDuration: 0.1, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        for contentIndex in (index + 1)..<stackView.arrangedSubviews.count {
            guard  let contentInStackView = stackView.arrangedSubviews[contentIndex] as? ArgContent else {
                fatalError()
            }

            contentInStackView.index = contentIndex
        }
    }

    func floatContent(content: ArgContent, index: Int) {

        let center = content.superview!.convert(content.center, to: VisualCodeEditorController.codeArea)

        stackView.removeArrangedSubview(content)
        VisualCodeEditorController.codeArea.addSubview(content)

        content.center = center

        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: index)
        blankView.translatesAutoresizingMaskIntoConstraints = false
        blankView.widthAnchor.constraint(equalTo: blankView.widthAnchor).isActive = true

        for contentIndex in (index + 1)..<stackView.arrangedSubviews.count {
            guard  let contentInStackView = stackView.arrangedSubviews[contentIndex] as? ArgContent else {
                fatalError()
            }

            contentInStackView.index = contentIndex - 1
        }
    }

    func insertBlankView(content: ArgContent, index: Int) {
        let blankView = UIView()
        stackView.insertArrangedSubview(blankView, at: index)
        blankView.translatesAutoresizingMaskIntoConstraints = false

        let blankViewWidth = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0)
        blankView.addConstraint(blankViewWidth)

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        blankViewWidth.constant = content.frame.width

        UIView.animate(withDuration: 0.1, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })
    }

    func moveBlankView(content: ArgContent, from: Int, to: Int) {
        let fromBlankView = stackView.arrangedSubviews[from]
        fromBlankView.removeConstraints(fromBlankView.constraints)
        let fromBlankViewWidth = NSLayoutConstraint(item: fromBlankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: content.frame.width)
        fromBlankView.addConstraint(fromBlankViewWidth)

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

        fromBlankViewWidth.constant = 0
        toBlankViewWidth.constant = content.frame.width

        UIView.animate(withDuration: 0.1, animations:
        {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        fromBlankView.removeFromSuperview()
    }

    func removeBlankView(content: UIView, index: Int) {
        let blankView = stackView.arrangedSubviews[index]

        blankView.removeConstraints(blankView.constraints)

        let blankViewWidth = NSLayoutConstraint(item: blankView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: content.frame.width)
        blankView.addConstraint(blankViewWidth)

        VisualCodeEditorController.codeArea.layoutIfNeeded()

        blankViewWidth.constant = 0

        UIView.animate(withDuration: 0.1, animations: {
            VisualCodeEditorController.codeArea.layoutIfNeeded()
        })

        stackView.arrangedSubviews[index].removeFromSuperview()
    }
}

class ArgVariable: ArgContent {

    init(value: String) {
        fatalError()
        //super.init(argContentValue: .Block(BlockData()))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class ArgText: ArgContent, UITextFieldDelegate {
    init(value: String, stackView: UIStackView) {
        super.init(argContentValue: .Text(value), stackView: stackView)

        self.translatesAutoresizingMaskIntoConstraints = false
        /*
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 3
        */

        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.purple.cgColor
        textField.layer.cornerRadius = 5
        textField.text = value
        textField.textAlignment = .center
        textField.sizeToFit()
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    textField.topAnchor.constraint(equalTo: self.topAnchor),
                    textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    textField.leftAnchor.constraint(equalTo: self.leftAnchor),
                    textField.rightAnchor.constraint(equalTo: self.rightAnchor)
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