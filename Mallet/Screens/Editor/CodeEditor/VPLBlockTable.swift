//
//  VPLBlockTable.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/08.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VPLBlockTable: UIView, BlockCategoryCollectionViewDelegate, UIGestureRecognizerDelegate {

    public let height: CGFloat = 300
    public let titleBarHeight: CGFloat = 70
    private let blockTypeCollectionViewHeight: CGFloat = 40

    private let visualCodeEditorController: VisualCodeEditorController

    private var blockTableView: UIView?

    init(visualCodeEditorController: VisualCodeEditorController) {
        self.visualCodeEditorController = visualCodeEditorController

        let width: CGFloat = UIScreen.main.bounds.size.width

        super.init(frame: CGRect(x: 0, y: 0, width: width, height: self.height))

        let titleBar = VPLBlockTableTitleBar(frame: CGRect(x: 0, y: 0, width: width, height: self.titleBarHeight))

        let blockTypeCollectionView = BlockCategoryCollectionView(frame: CGRect(x: 0, y: self.titleBarHeight, width: width, height: self.blockTypeCollectionViewHeight))
        blockTypeCollectionView.blockTypeCollectionViewDelegate = self

        self.addSubview(titleBar)
        self.addSubview(blockTypeCollectionView)

        self.setBlockCategory(blockCategory: .Block)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveView(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    fileprivate func setBlockCategory(blockCategory: BlockCategory) {
        self.blockTableView?.removeFromSuperview()

        let width: CGFloat = UIScreen.main.bounds.size.width

        let frame = CGRect(x: 0, y: self.titleBarHeight + self.blockTypeCollectionViewHeight, width: width, height: self.height - self.titleBarHeight - self.blockTypeCollectionViewHeight)

        switch blockCategory {
        case .Variable:
            let argBlockTableView = VPLArgBlockTableView(frame: frame, visualCodeEditorController: self.visualCodeEditorController)

            self.blockTableView = argBlockTableView

        default:
            let blockTableView = VPLBlockTableView(
                    frame: frame,
                    blockCategory: blockCategory,
                    visualCodeEditorController: visualCodeEditorController
            )

            self.blockTableView = blockTableView
        }

        if let blockTableView = self.blockTableView {
            self.addSubview(blockTableView)
        }
    }

    @objc func moveView(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)

        if velocity.y > 100 {
            self.visualCodeEditorController.hideVPLBlockTable()
        }

        if velocity.y < -100 {
            self.visualCodeEditorController.showVPLBlockTable()
        }
    }
}

private class VPLBlockTableTitleBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13, *) {
            self.backgroundColor = .secondarySystemGroupedBackground
        } else {
            self.backgroundColor = .white
        }

        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let bar = UIView(frame: CGRect(x: 0, y: 10, width: 50, height: 6))
        bar.center = CGPoint(x: self.frame.width / 2, y: 13)
        if #available(iOS 13, *) {
            bar.backgroundColor = .systemGray3
        } else {
            bar.backgroundColor = .gray
        }

        bar.layer.cornerRadius = 3

        self.addSubview(bar)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private class BlockCategoryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    public var blockTypeCollectionViewDelegate: BlockCategoryCollectionViewDelegate?

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        super.init(frame: frame, collectionViewLayout: layout)
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        self.delegate = self
        self.dataSource = self

        if #available(iOS 13, *) {
            self.backgroundColor = .secondarySystemGroupedBackground
        } else {
            self.backgroundColor = .gray
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BlockCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        let titleLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: cell.frame.size))
        titleLabel.textAlignment = .center
        titleLabel.text = BlockCategory.allCases[indexPath.row].rawValue

        cell.addSubview(titleLabel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.blockTypeCollectionViewDelegate?.setBlockCategory(blockCategory: BlockCategory.allCases[indexPath.row])
    }
}

private class VPLBlockTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    private let visualCodeEditorController: VisualCodeEditorController

    private let blockDataList: [BlockData]

    init(frame: CGRect, blockCategory: BlockCategory, visualCodeEditorController: VisualCodeEditorController) {
        self.visualCodeEditorController = visualCodeEditorController

        self.blockDataList = DefaultBlocks.blocks[blockCategory] ?? []

        super.init(frame: frame, style: .plain)

        self.delegate = self
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none

        let blockData = self.blockDataList[indexPath.row]

        let block = Block(blockData: blockData, index: 0, isOnTable: true, visualCodeEditorController: self.visualCodeEditorController)
        cell.addSubview(block)

        visualCodeEditorController.setBlockOnTable(block: block, cell: cell)

        return cell
    }


}

private class VPLArgBlockTableView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    private let fundamentalArgContentHeight: CGFloat = 70

    private let fundamentalArgContentsCollectionView: UICollectionView

    private let visualCodeEditorController: VisualCodeEditorController

    init(frame: CGRect, visualCodeEditorController: VisualCodeEditorController) {

        let fundamentalArgContentsCollectionViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: fundamentalArgContentHeight)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: fundamentalArgContentHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.fundamentalArgContentsCollectionView = UICollectionView(frame: fundamentalArgContentsCollectionViewFrame, collectionViewLayout: layout)

        self.visualCodeEditorController = visualCodeEditorController

        super.init(frame: frame)

        self.addSubview(self.fundamentalArgContentsCollectionView)
        self.fundamentalArgContentsCollectionView.delegate = self
        self.fundamentalArgContentsCollectionView.dataSource = self
        self.fundamentalArgContentsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        /*
        let blockTableViewFrame = CGRect(x: 0, y: 0 + fundamentalArgContentHeight, width: frame.width, height: frame.height - fundamentalArgContentHeight)
        let blockTableView = VPLBlockTableView(frame: blockTableViewFrame, blockCategory: .Variable, visualCodeEditorController: visualCodeEditorController)
        self.addSubview(blockTableView)
        */
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        let argContent: ArgContent!
        switch indexPath.row {
        case 0:
            argContent = ArgText(value: "", stackView: nil, index: -1, visualCodeEditorController: self.visualCodeEditorController, isOnTable: true)
        case 1:
            argContent = ArgInput(value: "", stackView: nil, index: -1, visualCodeEditorController: self.visualCodeEditorController, isOnTable: true)
        case 2:
            argContent = ArgBlock(blockData: BlockData(funcType: .ArgContent, funcName: "", contents: [
                BlockContentData(value: .Label("("), order: -1),
                BlockContentData(value: .Arg([]), order: 0),
                BlockContentData(value: .Label(")"), order: -1)
            ], indent: 0), stackView: nil, index: -1, visualCodeEditorController: self.visualCodeEditorController, isOnTable: true)
        default:
            return cell
        }

        argContent.setArgContentOnTable(cell: cell, superView: self.visualCodeEditorController.view)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

private protocol BlockCategoryCollectionViewDelegate {
    func setBlockCategory(blockCategory: BlockCategory)
}