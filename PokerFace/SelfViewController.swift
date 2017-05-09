//
//  SelfViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class SelfViewController: BasicViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var selfCollectionView: UICollectionView!

    
    let selfCellId = "self"
    let headerIdentifier = "CollectionReusableViewHeader"
    
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "晓东"
        
        layoutSelfCollectionView()
        
        self.selfCollectionView!.register(SelfCollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
    }


    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func settingButtonDidTouch(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "setting", sender: self)
        
    }
    
    //初始化 CollectionView
    func layoutSelfCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (selfCollectionView.frame.width + 20)/3
        let itemHeight = itemWidth * self.view.bounds.height / self.view.bounds.width + 20
        
        layout.itemSize = CGSize(width:itemWidth, height:itemHeight)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        // layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 60)
        
        selfCollectionView.showsVerticalScrollIndicator = false
        selfCollectionView.collectionViewLayout = layout
        selfCollectionView!.delegate = self
        selfCollectionView!.dataSource = self
        
    }
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //True 代表为自己上传的图片集合
            type = 1
        } else {
            type = 2
        }
        self.performSegue(withIdentifier: "myCollection", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myCollection" {
            let vc = segue.destination  as! CollectionViewController
            vc.type = type
            
        }
    }
    
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selfCellId, for: indexPath) as!SelfCollectionViewCell
        
        cell.selfImage.layer.cornerRadius = 2
        cell.selfLabel.text = "Airbnb"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 6
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: SelfCollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelfCollectionReusableView
            
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: 400, height: 30))
        reusableview.addSubview(label)
        
        if indexPath.section == 0 {
            label.text = "我的上传"
        } else {
            label.text = "我的收藏"
        }

        
        return reusableview
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destination
        destination.transitioningDelegate = self
    }
    
}
