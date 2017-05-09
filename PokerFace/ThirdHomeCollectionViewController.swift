//
//  ThirdHomeCollectionViewController.swift
//  PokerFace
//
//  Created by xiaodong on 03/05/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "thirdCell"

class ThirdHomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let kFirstVCId = "firstVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (self.view.bounds.width - 5)/2
        let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
        
        return CGSize(width:cellWidth, height:cellHeight)
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.backgroundColor = UIColor.green
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.cellDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        
        cell.addGestureRecognizer(doubleTap)
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func cellDoubleTap(sender: UITapGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        self.selectedIndexPath = IndexPath(row: cell.tag, section: 0)
        
        let vc = self.navigationController?.viewControllers[1] as! SecondHomeCollectionViewController
        vc.moreOrLess = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
