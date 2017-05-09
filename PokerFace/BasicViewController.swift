//
//  BasicViewController.swift
//  PokerFace
//
//  Created by xiaodong on 25/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    

}
