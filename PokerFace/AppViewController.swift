//
//  AppViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class AppViewController: BasicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
