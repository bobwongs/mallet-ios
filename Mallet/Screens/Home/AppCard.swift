//
//  AppCard.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/08/11.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class AppCard: UIView {

    let appName: String
    let appID: Int

    let homeViewController: HomeViewController

    init(appName: String, appID: Int, homeViewController: HomeViewController) {
        self.appName = appName
        self.appID = appID
        self.homeViewController = homeViewController

        super.init(frame: CGRect())

        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor

        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.axis = .horizontal
        //stackView.spacing = 30
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        ])

        let titleLabel = UILabel()
        titleLabel.text = self.appName
        titleLabel.sizeToFit()
        titleLabel.font = titleLabel.font.withSize(25)

        let editButton = UIButton(type: UIButton.ButtonType.system)
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = editButton.titleLabel?.font.withSize(25)
        editButton.addTarget(self, action: #selector(self.edit(_:)), for: .touchUpInside)

        let runButton = UIButton(type: UIButton.ButtonType.system)
        runButton.setTitle("Run", for: .normal)
        runButton.titleLabel?.font = runButton.titleLabel?.font.withSize(25)
        runButton.addTarget(self, action: #selector(self.run(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(runButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func edit(_ sender: UIButton) {
        homeViewController.edit(appID: appID)
    }

    @objc func run(_ sender: UIButton) {
        homeViewController.run(appID: appID)
    }
}

