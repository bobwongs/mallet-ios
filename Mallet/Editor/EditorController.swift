//
//  EditorController.swift
//  Mallet
//
//  Created by Katsu Matsuda on 2019/04/21.
//  Copyright © 2019 Katsu Matsuda. All rights reserved.
//

import UIKit

class EditorController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func RunButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RunApp", bundle: nil)
        guard  let controller: UIViewController = storyboard.instantiateInitialViewController() else {
            fatalError()
        }

        navigationController?.pushViewController(controller, animated: true)
    }

}
