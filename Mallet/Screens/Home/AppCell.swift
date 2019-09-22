//
//  AppCell.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/09/22.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var appIconImage: UIImageView!
    @IBOutlet weak var appTitleLabel: UILabel!

    private var delegate: AppCellDelegate?

    private var appID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.cellView.layer.cornerRadius = 15
    }

    func setCell(homeViewController: HomeViewController, appID: Int, appTitle: String) {
        self.delegate = homeViewController

        self.appID = appID

        self.appTitleLabel.text = appTitle
    }

    @IBAction func editButton(_ sender: Any) {
        delegate?.editApp(appID: self.appID ?? 0)
    }

    @IBAction func runButton(_ sender: Any) {
        delegate?.runApp(appID: self.appID ?? 0)
    }
}

protocol AppCellDelegate {
    func editApp(appID: Int)

    func runApp(appID: Int)
}
