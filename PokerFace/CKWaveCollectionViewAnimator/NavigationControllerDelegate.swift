//
//  NavigationControllerDelegate.swift
//  PokerFace
//
//  Created by xiaodong on 25/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = CKWaveCollectionViewAnimator()
        animator.animationDuration = 0.7
        
        if operation != UINavigationControllerOperation.push {
            
            animator.reversed = true
        }
        
        return animator
    }

}
