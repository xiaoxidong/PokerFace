//
//  SecondHomeCollectionViewController.swift
//  PokerFace
//
//  Created by xiaodong on 03/05/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "secondCell"

class SecondHomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let kThirdVCId = "thirdVC"
    
    var moreOrLess = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (self.view.bounds.width - 10)/3
        let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
        
        return CGSize(width:cellWidth, height:cellHeight)
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.purple
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.cellDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        
        cell.addGestureRecognizer(doubleTap)
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func cellDoubleTap(sender: UITapGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        self.selectedIndexPath = IndexPath(row: cell.tag, section: 0)
        
        if moreOrLess {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: kThirdVCId) as? ThirdHomeCollectionViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
