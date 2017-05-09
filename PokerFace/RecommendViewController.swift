//
//  RecommendViewController.swift
//  PokerFace
//
//  Created by xiaodong on 01/05/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func downloadAppButtonDidTouch(_ sender: UIBarButtonItem) {
        let urlString = "https://itunes.apple.com/us/app/airbnb/id401626263?mt=8"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }

}
