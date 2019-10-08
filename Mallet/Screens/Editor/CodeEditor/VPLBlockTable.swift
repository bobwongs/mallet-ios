//
//  VPLBlockTable.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/08.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VPLBlockTable: UIView, BlockTypeCollectionViewDelegate, UIGestureRecognizerDelegate {

    public let height: CGFloat = 300
    public let titleBarHeight: CGFloat = 70
    private let blockTypeCollectionViewHeight: CGFloat = 40

    private let visualCodeEditorController: VisualCodeEditorController

    init(visualCodeEditorController: VisualCodeEditorController) {
        self.visualCodeEditorController = visualCodeEditorController

        let width: CGFloat = UIScreen.main.bounds.size.width

        super.init(frame: CGRect(x: 0, y: 0, width: width, height: self.height))

        let titleBar = VPLBlockTableTitleBar(frame: CGRect(x: 0, y: 0, width: width, height: self.titleBarHeight))

        let blockTypeCollectionView = BlockTypeCollectionView(frame: CGRect(x: 0, y: self.titleBarHeight, width: width, height: self.blockTypeCollectionViewHeight))
        blockTypeCollectionView.blockTypeCollectionViewDelegate = self

        let blockTableView = VPLBlockTableView(
                frame: CGRect(x: 0, y: self.titleBarHeight + self.blockTypeCollectionViewHeight, width: width, height: self.height - self.titleBarHeight - self.blockTypeCollectionViewHeight),
                blockDataList: DefaultBlocks.blocks,
                visualCodeEditorController: visualCodeEditorController
        )

        self.addSubview(titleBar)
        self.addSubview(blockTypeCollectionView)
        self.addSubview(blockTableView)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveView(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    fileprivate func changeBlockType(blockType: BlockType) {
    }

    @objc func moveView(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)

        print(velocity.y)

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

private class BlockTypeCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    public var blockTypeCollectionViewDelegate: BlockTypeCollectionViewDelegate?

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
        return BlockType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        let titleLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: cell.frame.size))
        titleLabel.textAlignment = .center
        titleLabel.text = BlockType.allCases[indexPath.row].rawValue

        cell.addSubview(titleLabel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.blockTypeCollectionViewDelegate?.changeBlockType(blockType: BlockType.allCases[indexPath.row])
    }
}

private class VPLBlockTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    private let visualCodeEditorController: VisualCodeEditorController

    private let blockDataList: [BlockData]

    init(frame: CGRect, blockDataList: [BlockData], visualCodeEditorController: VisualCodeEditorController) {
        self.visualCodeEditorController = visualCodeEditorController

        self.blockDataList = blockDataList

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

private class VPLVariableTableView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private protocol BlockTypeCollectionViewDelegate {
    func changeBlockType(blockType: BlockType)
}