//
//  VPLBlockTable.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/10/08.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class VPLSelectionView: UIView, VPLCategoryScrollViewDelegate, UIGestureRecognizerDelegate {

    public let height: CGFloat = 300
    public let titleBarHeight: CGFloat = 70
    private let blockTypeCollectionViewHeight: CGFloat = 40

    private let VPLController: VisualCodeEditorController

    private var blockTableView: UIView?

    private var stackView = UIStackView()

    init(visualCodeEditorController: VisualCodeEditorController) {
        self.VPLController = visualCodeEditorController

        let width: CGFloat = UIScreen.main.bounds.size.width

        super.init(frame: CGRect(x: 0, y: 0, width: width, height: self.height))

        let titleBar = VPLBlockSelectionViewTitleBar(frame: CGRect(x: 0, y: 0, width: width, height: self.titleBarHeight))

        let blockTypeCollectionView = BlockCategoryCollectionView(frame: CGRect(x: 0, y: self.titleBarHeight, width: width, height: self.blockTypeCollectionViewHeight), initialCategory: .Variable)
        blockTypeCollectionView.blockTypeCollectionViewDelegate = self

        self.addSubview(titleBar)
        self.addSubview(blockTypeCollectionView)
        self.addSubview(self.stackView)

        self.stackView.axis = .vertical
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    stackView.topAnchor.constraint(equalTo: blockTypeCollectionView.bottomAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
                ]
        )

        self.setBlockCategory(blockCategory: .Variable)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveView(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    fileprivate func setBlockCategory(blockCategory: BlockCategory) {
        for view in self.stackView.arrangedSubviews {
            self.stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        if blockCategory == .Variable {
            let fundamentalArgContentsScrollView = VPLFundamentalArgContentsScrollView(VPLController: self.VPLController)

            self.stackView.addArrangedSubview(fundamentalArgContentsScrollView)

            fundamentalArgContentsScrollView.translatesAutoresizingMaskIntoConstraints = false
            fundamentalArgContentsScrollView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }

        let blockTableView = VPLBlockTableView(frame: CGRect(), blockCategory: blockCategory, VPLController: self.VPLController)
        self.stackView.addArrangedSubview(blockTableView)
    }

    @objc private func moveView(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)

        if velocity.y > 100 {
            self.VPLController.hideVPLBlockTable()
        }

        if velocity.y < -100 {
            self.VPLController.showVPLBlockTable()
        }
    }
}

private class VPLBlockSelectionViewTitleBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13, *) {
            self.backgroundColor = .secondarySystemGroupedBackground
        } else {
            self.backgroundColor = .white
        }

        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let bar = UIView()
        if #available(iOS 13, *) {
            bar.backgroundColor = .systemGray3
        } else {
            bar.backgroundColor = .gray
        }

        bar.layer.cornerRadius = 3

        self.addSubview(bar)

        bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    bar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                    bar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    bar.widthAnchor.constraint(equalToConstant: 50),
                    bar.heightAnchor.constraint(equalToConstant: 6)
                ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

/*
private class VPLCategoryScrollView: UIScrollView {

    private let vplCategoryScrollViewDelegate: VPLCategoryScrollViewDelegate

    init(frame: CGRect, vplCategoryScrollViewDelegate: VPLCategoryScrollViewDelegate) {

        self.vplCategoryScrollViewDelegate = vplCategoryScrollViewDelegate

        super.init(frame: frame)

        let stackView = UIStackView()
        stackView.axis = .horizontal

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
                ]
        )

        for category in BlockCategory.allCases {
            let tab = CategoryTab(category: category)
            tab.addTarget(self, action: #selector(setBlockCategory(_:)), for: .touchUpInside)
            tab.setTitle(category.rawValue, for: .normal)
            tab.titleLabel?.textAlignment = .center
            stackView.addArrangedSubview(tab)
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc private func setBlockCategory(_ sender: CategoryTab) {
        self.vplCategoryScrollViewDelegate.setBlockCategory(blockCategory: sender.category)
    }

    private class CategoryTab: UIButton {
        let category: BlockCategory

        init(category: BlockCategory) {
            self.category = category

            super.init(frame: CGRect())
        }

        required init?(coder: NSCoder) {
            fatalError()
        }

    }

}
*/

private class BlockCategoryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    public var blockTypeCollectionViewDelegate: VPLCategoryScrollViewDelegate?

    private var selectedCategory: BlockCategory

    init(frame: CGRect, initialCategory: BlockCategory) {
        self.selectedCategory = initialCategory

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 40)
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

        for subView in cell.subviews {
            subView.removeFromSuperview()
        }

        let category = BlockCategory.allCases[indexPath.row]

        let titleLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: cell.frame.size))
        titleLabel.textAlignment = .center
        titleLabel.text = category.rawValue

        if category == self.selectedCategory {
            if #available(iOS 13, *) {
                cell.backgroundColor = .systemGray3
            } else {
                cell.backgroundColor = .gray
            }
        } else {
            cell.backgroundColor = .clear
        }

        cell.addSubview(titleLabel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = BlockCategory.allCases[indexPath.row]

        self.blockTypeCollectionViewDelegate?.setBlockCategory(blockCategory: self.selectedCategory)

        collectionView.reloadData()
    }
}

private class VPLBlockTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    private let visualCodeEditorController: VisualCodeEditorController

    private let blockDataList: [BlockData]

    init(frame: CGRect, blockCategory: BlockCategory, VPLController: VisualCodeEditorController) {
        self.visualCodeEditorController = VPLController

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

        if blockData.funcType == .ArgContent {
            let argContent = ArgBlock(blockData: blockData, stackView: nil, index: -1, visualCodeEditorController: self.visualCodeEditorController, isOnTable: true)
            cell.addSubview(argContent)

            argContent.setArgContentOnTable(cellInTableView: cell, superView: self.visualCodeEditorController.view)
        } else {
            let block = Block(blockData: blockData, index: 0, isOnTable: true, visualCodeEditorController: self.visualCodeEditorController)
            cell.addSubview(block)

            visualCodeEditorController.setBlockOnTable(block: block, cell: cell)
        }

        return cell
    }


}

private class VPLVariableScrollView: UIScrollView, UIScrollViewDelegate {

    private let VPLController: VisualCodeEditorController

    private var scrollStartPoint: CGPoint?

    init(category: BlockCategory, VPLController: VisualCodeEditorController) {

        self.VPLController = VPLController

        super.init(frame: CGRect())

        self.showsVerticalScrollIndicator = false

        self.scrollStartPoint = self.contentOffset

        self.delegate = self

        let stackView = UIStackView()

        stackView.spacing = 30

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                    stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: VisualCodeEditorController.blockDefaultIndentSize),
                    stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -VisualCodeEditorController.blockDefaultIndentSize)
                ]
        )

        if let blocks = DefaultBlocks.blocks[category] {
            for blockData in blocks {
                let argContent = ArgBlock(blockData: blockData, stackView: nil, index: -1, visualCodeEditorController: self.VPLController, isOnTable: true)

                let cell = UIView()

                stackView.addArrangedSubview(cell)

                cell.addSubview(argContent)

                cell.translatesAutoresizingMaskIntoConstraints = false

                argContent.layoutIfNeeded()

                NSLayoutConstraint.activate(
                        [
                            cell.widthAnchor.constraint(equalToConstant: argContent.frame.width),
                            cell.heightAnchor.constraint(equalToConstant: argContent.frame.height)
                        ]
                )

                argContent.setArgContentOnTable(cellInStackView: cell, superView: self.VPLController.view)
            }
        }

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollStartPoint = self.scrollStartPoint {
            scrollView.contentOffset.y = scrollStartPoint.y
        }
    }
}

private class VPLFundamentalArgContentsScrollView: UIScrollView, UIScrollViewDelegate {

    private let VPLController: VisualCodeEditorController

    private var scrollStartPoint: CGPoint?

    init(VPLController: VisualCodeEditorController) {

        self.VPLController = VPLController

        super.init(frame: CGRect())

        self.showsVerticalScrollIndicator = false

        self.scrollStartPoint = self.contentOffset

        self.delegate = self

        let stackView = UIStackView()

        stackView.spacing = 30

        stackView.alignment = .center

        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
                [
                    stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                    stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: VisualCodeEditorController.blockDefaultIndentSize),
                    stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -VisualCodeEditorController.blockDefaultIndentSize)
                ]
        )

        for index in 0..<3 {
            let argContent: ArgContent!
            switch (index) {
            case 0:
                argContent = ArgText(value: "", stackView: nil, index: -1, visualCodeEditorController: self.VPLController, isOnTable: true)
            case 1:
                argContent = ArgInput(value: "", stackView: nil, index: -1, visualCodeEditorController: self.VPLController, isOnTable: true)
            case 2:
                argContent = ArgBlock(blockData: BlockData(funcType: .Block, funcName: "", contents: [
                    BlockContentData(value: .Label("("), order: -1),
                    BlockContentData(value: .Arg([]), order: 0),
                    BlockContentData(value: .Label(")"), order: -1)
                ], indent: 0), stackView: nil, index: -1, visualCodeEditorController: self.VPLController, isOnTable: true)
            default:
                continue
            }

            let cell = UIView()

            stackView.addArrangedSubview(cell)

            cell.addSubview(argContent)

            cell.translatesAutoresizingMaskIntoConstraints = false

            argContent.layoutIfNeeded()

            NSLayoutConstraint.activate(
                    [
                        cell.widthAnchor.constraint(equalToConstant: argContent.frame.width),
                        cell.heightAnchor.constraint(equalToConstant: argContent.frame.height)
                    ]
            )

            argContent.setArgContentOnTable(cellInStackView: cell, superView: self.VPLController.view)
        }

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollStartPoint = self.scrollStartPoint {
            scrollView.contentOffset.y = scrollStartPoint.y
        }
    }
}

private protocol VPLCategoryScrollViewDelegate {
    func setBlockCategory(blockCategory: BlockCategory)
}