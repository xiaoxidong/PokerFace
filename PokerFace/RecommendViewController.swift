//
//  RecommendViewController.swift
//  PokerFace
//
//  Created by xiaodong on 01/05/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import CHIPageControl

class RecommendViewController: UIViewController {

    var pageControl = CHIPageControlChimayo()
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl = CHIPageControlChimayo(frame: CGRect(x: 0, y:0, width: 100, height: 20))
        pageControl.numberOfPages = 4
        pageControl.radius = 4
        pageControl.tintColor = .red
        pageControl.currentPageTintColor = .green
        pageControl.padding = 6
        
        //pageControl.progress = 0.5
        
        self.navigationItem.titleView = pageControl
        
    }

    @IBAction func downloadAppButtonDidTouch(_ sender: UIBarButtonItem) {
//        let urlString = "https://itunes.apple.com/us/app/airbnb/id401626263?mt=8"
//        if let url = URL(string: urlString) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        
        pageControl.set(progress: 3, animated: true)
    }
    
    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }

}
