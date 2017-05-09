//
//  UploadViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class SelectPhotoViewController: BasicViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var selectPhotoCollectionView: UICollectionView!
    
    let kCellId = "select"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCollectionView()
    }
    
    //初始化 CollectionView
    func layoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        let cellWidth = (self.view.bounds.width - 10)/3
        let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
        
        layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        
        selectPhotoCollectionView.collectionViewLayout = layout
        selectPhotoCollectionView!.delegate = self
        selectPhotoCollectionView!.dataSource = self
    }

    

    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func combineButtonDidTouch(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "combine", sender: self)
    }
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectButton.setImage(UIImage(named: "picture_select"), for: UIControlState.selected)
        
    }
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! SelectPhotoCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}
