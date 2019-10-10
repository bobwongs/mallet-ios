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

    private var isOnTable: Bool

    private var defaultSuperView: UIView?

    init(argContentValue: ArgContentType, stackView: UIStackView?, index: Int, isOnTable: Bool) {

        self.stackView = stackView

        self.currentStackView = stackView

        self.value = argContentValue

        self.isOnTable = isOnTable

        super.init(frame: CGRect())

        self.setArgContentOnTable()

        setContentIndex(index: index)

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenu(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    func setArgContentOnTable(cell: UIView? = nil, superView: UIView? = nil) {
        if let cell = cell, let superView = superView {
            cell.addSubview(self)

            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                    [
                        self.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                        self.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                    ]
            )

            self.defaultSuperView = superView
        }

        self.isUserInteractionEnabled = true

        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.dragUI(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

    @objc func showMenu(_ sender: UITapGestureRecognizer) {
        becomeFirstResponder()

        let menu = UIMenuController.shared
        menu.isMenuVisible = true
        menu.arrowDirection = .down
        menu.setTargetRect(self.bounds, in: self)

        let deleteMenu = UIMenuItem(title: "Delete", action: #selector(deleteContent(_:)))
        let menuItems = [deleteMenu]
        menu.menuItems = menuItems
        menu.setMenuVisible(true, animated: true)
    }

    @objc func deleteContent(_ sender: UIMenuItem) {
        self.removeContent()
    }

    @objc func dragUI(_ sender: UIPanGestureRecognizer) {
        self.superview?.bringSubviewToFront(self)

        if sender.state == .began {
            if self.isOnTable {
                HapticFeedback.blockFeedback()

                self.isOnTable = false
                self.delegate?.generateNewArgContent(content: self)

                self.center = self.superview?.convert(self.center, to: self.defaultSuperView) ?? CGPoint()
                self.defaultSuperView?.addSubview(self)
            }

            self.translatesAutoresizingMaskIntoConstraints = true
            if self.index != -1 {
                floatContent()
            }
        }

        if sender.state == .ended {
            if self.index == -1 {
                self.removeContent()
            } else {
                insertContent()
            }

            return
        }

        let move = sender.translation(in: self)
        sender.setTranslation(CGPoint.zero, in: self)

        self.center.x += move.x
        self.center.y += move.y

        self.stackView = delegate?.findArgViewStack(argContentView: self)

        if self.stackView == nil || (self.stackView != self.currentStackView) {
            self.index = -1

            if self.currentIndex != -1 {
                removeBlankView()

                self.currentIndex = -1
                self.currentStackView = self.stackView

                return
            }
        }

        guard let stackView = self.stackView else {
            return
        }

        var minDis = stackView.bounds.width * 100000
        var minIndex = 0
        var index = 0

        for contentIndex in 0..<stackView.arrangedSubviews.count {
            let contentInStackView = stackView.arrangedSubviews[contentIndex]

            if !(contentInStackView is ArgContent) {
                continue
            }

            let contentFrame = contentInStackView.superview!.convert(contentInStackView.frame, to: VisualCodeEditorController.codeArea)

            if index == 0 {
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

        self.index = minIndex
        if self.currentIndex == -1 {
            insertBlankView()
        } else {
            moveBlankView(from: self.currentIndex, to: self.index)
        }

        self.currentStackView = self.stackView
        self.currentIndex = self.index
    }

    override class var layerClass: AnyClass {
        return super.layerClass
    }

    func removeContent() {
        if self.stackView != nil {
            self.floatContent()
            self.removeBlankView()
        }

        self.removeFromSuperview()
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

        var index = self.index + 1
        for contentIndex in (self.index + 1)..<stackView.arrangedSubviews.count {
            guard let contentInStackView = stackView.arrangedSubviews[contentIndex] as? ArgContent else {
                continue
            }

            contentInStackView.setContentIndex(index: index)
            index += 1
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


        var index = self.index + 1
        for contentIndex in (self.index + 1)..<stackView.arrangedSubviews.count {
            guard let contentInStackView = stackView.arrangedSubviews[contentIndex] as? ArgContent else {
                continue
            }

            contentInStackView.setContentIndex(index: index - 1)
            index += 1
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

        stackView.removeArrangedSubview(fromBlankView)
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

class ArgInput: ArgContent, UITextFieldDelegate {

    let textField = UITextField()

    let stackView = UIStackView()

    init(value: String, stackView: UIStackView?, index: Int, visualCodeEditorController: VisualCodeEditorController, isOnTable: Bool) {

        super.init(argContentValue: .Text(value), stackView: stackView, index: index, isOnTable: isOnTable)

        self.delegate = visualCodeEditorController

        self.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 13, *) {
            self.backgroundColor = .placeholderText
        } else {
            self.backgroundColor = .white
        }
        self.layer.cornerRadius = 5

        let padding: CGFloat = 5
        self.stackView.axis = .horizontal
        self.stackView.spacing = 3
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding)
        ])

        textField.delegate = self
        textField.layer.cornerRadius = 3
        textField.text = value
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.sizeToFit()
        self.stackView.addArrangedSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
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

    public func getCodeStr() -> String {
        return "\(self.textField.text ?? "")"
    }
}

class ArgText: ArgInput {
    override init(value: String, stackView: UIStackView?, index: Int, visualCodeEditorController: VisualCodeEditorController, isOnTable: Bool) {
        super.init(value: value, stackView: stackView, index: index, visualCodeEditorController: visualCodeEditorController, isOnTable: isOnTable)

        let openLabel = UILabel()
        openLabel.text = "\""

        let closeLabel = UILabel()
        closeLabel.text = "\""

        self.stackView.insertArrangedSubview(openLabel, at: 0)
        self.stackView.addArrangedSubview(closeLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func getCodeStr() -> String {
        return "\"\(self.textField.text ?? "")\""
    }
}

class ArgBlock: ArgContent {

    public let initialBlockData: BlockData

    private let blockView: BlockView

    init(blockData: BlockData, stackView: UIStackView?, index: Int, visualCodeEditorController: VisualCodeEditorController, isOnTable: Bool) {
        self.initialBlockData = blockData

        self.blockView = BlockView(blockData: blockData, visualCodeEditorController: visualCodeEditorController)

        super.init(argContentValue: .Block(blockData), stackView: stackView, index: index, isOnTable: isOnTable)

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

    public func getCodeStr() -> String {
        return blockView.getCodeStr()
    }
}

class ArgVariable: ArgContent {

    public let varName: String

    init(varName: String, stackView: UIStackView?, index: Int, visualCodeEditorController: VisualCodeEditorController, isOnTable: Bool) {

        self.varName = varName

        super.init(argContentValue: .Text(varName), stackView: stackView, index: index, isOnTable: isOnTable)

        self.delegate = visualCodeEditorController

        self.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 13, *) {
            self.backgroundColor = .placeholderText
        } else {
            self.backgroundColor = .white
        }
        self.layer.cornerRadius = 5

        let padding: CGFloat = 5

        let label = UILabel()
        label.text = varName
        label.textAlignment = .center
        label.sizeToFit()

        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    label.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
                    label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
                    label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
                    label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding)
                ]
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public func getCodeStr() -> String {
        return varName
    }
}

protocol ArgContentViewDelegate {
    func findArgViewStack(argContentView: ArgContent) -> UIStackView?

    func generateNewArgContent(content: UIView)
}