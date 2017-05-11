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
    var editModel = false
    
    var itemSizes = [CGSize]()
    var moveItemSizes = [CGSize]()
    var images = ["1", "2", "3"]
    
    var begainIndexpath: IndexPath?
    var targetIndexPath: IndexPath?
    
    var offset = CGPoint(x: 0, y: 0)
    
    var selectedIndexPath = IndexPath()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemSizes = [CGSize(width: self.view.bounds.width, height: self.view.bounds.height), CGSize(width: self.view.bounds.width, height: self.view.bounds.height), CGSize(width: self.view.bounds.width, height: self.view.bounds.height)]
        
        layoutCollectionView()
        
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
        combineCollectionView.showsVerticalScrollIndicator = false
        combineCollectionView!.delegate = self
        combineCollectionView!.dataSource = self
    }
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if selectedIndexPath == [] {
            selectedIndexPath = indexPath
            
            editModel = !editModel
            for itmesize in itemSizes {
                let moveItmesize = CGSize(width: self.view.bounds.width, height: itmesize.height * 0.8)
                moveItemSizes.append(moveItmesize)
            }
            combineCollectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
            combineCollectionView.contentOffset.y += -30
            
            combineCollectionView.reloadData()
            
        } else if selectedIndexPath != [] && selectedIndexPath != indexPath {
            selectedIndexPath = indexPath
            combineCollectionView.reloadData()
            
        } else {
            editModel = !editModel
            selectedIndexPath = []
            
            moveItemSizes.removeAll()
            combineCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            combineCollectionView.contentOffset.y += 30
            combineCollectionView.reloadData()
        }

    }

    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! CombineImagesCollectionViewCell
        
        cell.singleImage.image = UIImage(named: images[indexPath.row])
        cell.singleImage.contentMode = UIViewContentMode.scaleAspectFit
        
        if indexPath == selectedIndexPath {
            cell.upButton.isHidden = false
            cell.downButton.isHidden = false
            cell.upLineButton.isHidden = false
            cell.downLineButton.isHidden = false
        } else {
            cell.upButton.isHidden = true
            cell.downButton.isHidden = true
            cell.upLineButton.isHidden = true
            cell.downLineButton.isHidden = true
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.photoLongPress(gesture:)))
        cell.singleImage.isUserInteractionEnabled = true
        cell.singleImage.addGestureRecognizer(longPressGesture)
        
        cell.tag = indexPath.row
        
        let upButtonDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.cutDidMove(gesture:)))
        let downButtonDragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.cutDidMove(gesture:)))
        cell.downButton.addGestureRecognizer(downButtonDragGesture)
        cell.upButton.addGestureRecognizer(upButtonDragGesture)
        
        return cell
    }
    
    func cutDidMove(gesture: UITapGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.changed {
            let point = gesture.location(in: combineCollectionView)
            print(point)
        }
    }
    
    
    //长按移动事件
    func photoLongPress(gesture: UILongPressGestureRecognizer) {
        combineCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let point = gesture.location(in: combineCollectionView)
        
        var scale: CGFloat = 0
        if editModel {
            scale = combineCollectionView.contentSize.height / 0.8 / self.view.bounds.height
        } else {
            scale = combineCollectionView.contentSize.height / self.view.bounds.height
        }
        
        
        if gesture.state == UIGestureRecognizerState.began {
            
            begainIndexpath = combineCollectionView.indexPathForItem(at: point)!
            
            moveModel = true
            offset = combineCollectionView.contentOffset
            
            moveItemSizes.removeAll()
            
            for itmesize in itemSizes {
                
                let moveItmesize = CGSize(width: self.view.bounds.width, height: itmesize.height/scale)
                moveItemSizes.append(moveItmesize)
            }

            combineCollectionView.reloadData()
            
            
        } else if gesture.state == UIGestureRecognizerState.changed {
            
            let newPoint = CGPoint(x: point.x * scale, y: point.y * scale)
            
            targetIndexPath = combineCollectionView.indexPathForItem(at: newPoint)
            

            // 更新数据
            let obj = itemSizes[(begainIndexpath?.row)!]
            itemSizes.remove(at: (begainIndexpath?.row)!)
            itemSizes.insert(obj, at: (targetIndexPath?.row)!)
            
            let obj2 = moveItemSizes[(begainIndexpath?.row)!]
            moveItemSizes.remove(at: (begainIndexpath?.row)!)
            moveItemSizes.insert(obj2, at: (targetIndexPath?.row)!)
            
            
            //交换位置
            combineCollectionView.moveItem(at: begainIndexpath!, to: targetIndexPath!)
            
            combineCollectionView.reloadData()
            
            begainIndexpath = targetIndexPath

            
        } else if gesture.state == UIGestureRecognizerState.ended {
            moveModel = false
            editModel = false
            
            combineCollectionView.contentOffset = offset
            
            moveItemSizes.removeAll()
            
            combineCollectionView.reloadData()
            
            combineCollectionView.endInteractiveMovement()

        }
        
        
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
        if moveModel || editModel {
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
