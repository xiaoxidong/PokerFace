//
//  CombineImagesViewController.swift
//  PokerFace
//
//  Created by xiaodong on 27/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class CombineImagesViewController: BasicViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var combineCollectionView: UICollectionView!

    let kCellId = "combine"
    var moveModel = false
    
    var itemSizes = [CGSize]()
    var moveItemSizes = [CGSize]()
    
    var begainIndexpath: IndexPath?
    var targetIndexPath: IndexPath?
    
    var offset = CGPoint(x: 0, y: 0)
    
    let dragingItem = CombineImagesCollectionViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemSizes = [CGSize(width: self.view.bounds.width - 100, height: self.view.bounds.height), CGSize(width: self.view.bounds.width - 100, height: 200), CGSize(width: self.view.bounds.width - 100, height: 100)]
        
        layoutCollectionView()
        
        dragingItem.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 10)
        dragingItem.backgroundColor = UIColor.purple
        
        combineCollectionView.addSubview(dragingItem)
        
        

    }
    
    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func doneButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController!.viewControllers.remove(at: self.navigationController!.viewControllers.count - 2)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //初始化 CollectionView
    func layoutCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        
//        let cellWidth = self.view.bounds.width
//        let cellHeight = self.view.bounds.height
//        
//        layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
//        //列间距,行间距,偏移
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0)
//        
//        combineCollectionView.collectionViewLayout = layout
        
        combineCollectionView.showsVerticalScrollIndicator = false
        combineCollectionView!.delegate = self
        combineCollectionView!.dataSource = self
    }
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! CombineImagesCollectionViewCell
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor.purple
        } else if indexPath.row == 1 {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.photoLongPress(gesture:)))
        cell.singleImage.isUserInteractionEnabled = true
        
        cell.singleImage.addGestureRecognizer(longPressGesture)
        
        cell.tag = indexPath.row
        
        return cell
    }
    
//    private lazy var dragingItem: UICollectionViewCell = {
//        
//        let cell = CombineImagesCollectionViewCell(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 1))
//        //cell.isHidden = true
//        return cell
//    }()
    
    func photoLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: combineCollectionView)
        let scale = combineCollectionView.contentSize.height / self.view.bounds.height
        
        if gesture.state == UIGestureRecognizerState.began {
            /*


            let item = combineCollectionView.cellForItem(at: begainIndexpath) as? CombineImagesCollectionViewCell
            item?.isHidden = true
            
//            let dragingItem = CombineImagesCollectionViewCell()
//            dragingItem.singleImage.image = item?.singleImage.image
            

            //放大效果(此处可以根据需求随意修改)
            //dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            if let selectedIndexPath = combineCollectionView.indexPathForItem(at: gesture.location(in: self.combineCollectionView)) {
                combineCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            }
            
            */
            
            begainIndexpath = combineCollectionView.indexPathForItem(at: point)!
            
            moveModel = true
            offset = combineCollectionView.contentOffset
            
            
            
            for itmesize in itemSizes {
                let moveItmesize = CGSize(width: self.view.bounds.width - 100, height: itmesize.height/scale)
                moveItemSizes.append(moveItmesize)
            }
            
            let item = combineCollectionView.cellForItem(at: begainIndexpath!) as? CombineImagesCollectionViewCell
            item?.isHidden = false
            
            dragingItem.isHidden = true
            dragingItem.frame = (item?.frame)!
            
            combineCollectionView.reloadData()
            
            

//            //dragingItem.frame = CGRect(x: 0, y: (item?.frame.origin.y)! * scale, width: self.view.bounds.width, height: (item?.frame.size.height)! * scale)
//
            item?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            
        } else if gesture.state == UIGestureRecognizerState.changed {
            //combineCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
            //combineCollectionView.beginInteractiveMovementForItem(at: begainIndexpath!)
            
//            dragingItem.center = point
//            
            let newPoint = CGPoint(x: point.x * scale, y: point.y * scale)
            
            targetIndexPath = combineCollectionView.indexPathForItem(at: newPoint)
            

            // 更新数据
            let obj = itemSizes[(begainIndexpath?.item)!]
            itemSizes.remove(at: (begainIndexpath?.row)!)
            itemSizes.insert(obj, at: (targetIndexPath?.item)!)
            
            //交换位置
            combineCollectionView.moveItem(at: begainIndexpath!, to: targetIndexPath!)
            
            combineCollectionView.reloadData()
            
            begainIndexpath = targetIndexPath

            
            
        } else if gesture.state == UIGestureRecognizerState.ended {
            moveModel = false
            
            combineCollectionView.contentOffset = offset
            
            moveItemSizes.removeAll()
            
            combineCollectionView.reloadData()
            
            combineCollectionView.endInteractiveMovement()

        }
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
//        
//        return
//    }
    
//    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        //调整数据源数据的顺序
//    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if moveModel {
            return moveItemSizes[indexPath.row]
        } else {
            return itemSizes[indexPath.row]
        }
        
        
    }
    
    //MARK: - 产生随机色
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/256.0, green: CGFloat(arc4random_uniform(128))/256.0+0.5, blue: CGFloat(arc4random_uniform(128))/256.0+0.5, alpha: 1)
    }

}
