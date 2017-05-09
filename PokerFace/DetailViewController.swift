//
//  DetailViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class DetailViewController: BasicViewController {
    @IBOutlet weak var titleButton: UIButton!
    
    var detailScrollView = UIScrollView()
    
    let moreView: MoreView = Bundle.main.loadNibNamed("DetailMoreView", owner: self, options: nil)?.first as! MoreView

    var hideStatusBar = false
    var moreViewIsOn = false
    var isSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutLayer()
        
        titleButton.setTitle("Airbnb", for: UIControlState.normal)
        
        let a = titleButton.titleLabel!.bounds.width
        let b = titleButton.imageView!.bounds.width
        
        print(a)
        print(b)
        
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleButton.titleLabel!.bounds.width, 0, -titleButton.titleLabel!.bounds.width)
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -titleButton.imageView!.bounds.width, 0, titleButton.imageView!.bounds.width)
        
        
        detailScrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(detailScrollView)
        
        
        let image = UIImage(named: "aaa")
        let imageHeight = image!.size.height * self.view.bounds.width / image!.size.width
        
        detailScrollView.contentSize = CGSize(width: self.view.bounds.width, height: imageHeight)
        detailScrollView.setContentOffset(CGPoint(x: 0, y: 65), animated: false)

        detailScrollView.scrollsToTop = false
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: imageHeight))
        imageView.contentMode = UIViewContentMode.scaleToFill
        imageView.image = image
        detailScrollView.addSubview(imageView)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.showOrHideNavigationAndStatusBar))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //self.showOrHideNavigationAndStatusBar()
        }
        

    }
    
    //初始化更多事件
    func layoutLayer() {
        //初始化下拉选择，添加事件
        moreView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        moreView.layer.shadowColor = UIColor.black.cgColor
        moreView.layer.shadowOffset = CGSize(width: 0, height: -2)
        moreView.layer.shadowOpacity = 0.1
        
        if isSaved {
            moreView.saveButton.setImage(UIImage(named: "saved"), for: UIControlState.normal)
            
        } else {
            moreView.saveButton.setImage(UIImage(named: "save"), for: UIControlState.normal)
            
        }
        
        //分类点击事件
        moreView.saveButton.addTarget(self, action: #selector(self.saveButtonDidTouch), for: UIControlEvents.touchUpInside)
        moreView.shareButton.addTarget(self, action: #selector(self.shareButtonDidTouch), for: UIControlEvents.touchUpInside)
        moreView.downloadButton.addTarget(self, action: #selector(self.downloadButtonDidTouch), for: UIControlEvents.touchUpInside)
        
        //点击其他位置的时候也收起下拉
        let windowGesture = UITapGestureRecognizer(target: self, action: #selector(self.showOrHideMoreView))
        moreView.addGestureRecognizer(windowGesture)
    }
    
    //下拉显示和隐藏
    func showOrHideMoreView() {
        if !moreViewIsOn {
            UIApplication.shared.keyWindow?.addSubview(moreView)
            
        } else {
            moreView.removeFromSuperview()
        }
        
        moreViewIsOn = !moreViewIsOn
    }
    
    //收藏事件
    func saveButtonDidTouch() {
        if !isSaved {
            moreView.saveButton.setImage(UIImage(named: "saved"), for: UIControlState.normal)

        } else {
            moreView.saveButton.setImage(UIImage(named: "save"), for: UIControlState.normal)

        }
        
        isSaved = !isSaved
    }
    
    //分享事件
    func shareButtonDidTouch() {
        
    }
    
    //下载事件
    func downloadButtonDidTouch() {
        
    }

    //显示隐藏更多操作
    func showOrHideNavigationAndStatusBar() {
        if !hideStatusBar {
            //self.detailScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

            //UIApplication.shared.statusBarFrame = CGRect(x: 0, y: -20, width: self.view.bounds.width, height: 20)
            
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.hideStatusBar = true
            self.setNeedsStatusBarAppearanceUpdate()
            
        }else {
//            if self.detailScrollView.contentOffset.y == 0 {
//                self.detailScrollView.setContentOffset(CGPoint(x: 0, y: 65), animated: false)
//            }

            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.hideStatusBar = false
            self.setNeedsStatusBarAppearanceUpdate()
            
        }
        
    }
    

    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func moreButtonDidTouch(_ sender: UIBarButtonItem) {
        //更多按钮事件
        showOrHideMoreView()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    @IBAction func titleButtonDidTouch(_ sender: UIButton) {
        self.performSegue(withIdentifier: "detailApp", sender: self)
    }
}
