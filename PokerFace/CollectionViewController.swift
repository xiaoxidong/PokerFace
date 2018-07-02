//
//  CollectionViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import BouncyLayout
import PopupDialog

class CollectionViewController: BasicViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var titleButton: UIButton!

    var type = 0
    var editModel = false
    var leftButonInUse = false
    
    let kCellId = "aaCollection"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutCollectionView()
        setTitleButton()
        
    }
    
    func setTitleButton() {
        if type == 1 {
            if editModel {
                titleButton.setTitle("Airbnb", for: UIControlState.normal)
                titleButton.setImage(UIImage(named: ""), for: UIControlState.normal)
                
            } else {
                
                titleButton.setTitle("Airbnb", for: UIControlState.normal)
                titleButton.setImage(UIImage(named: "link"), for: UIControlState.normal)

            }
            
        }else if type == 2 {
            if editModel {
                titleButton.setTitle("Facebook", for: UIControlState.normal)
                titleButton.setImage(UIImage(named: ""), for: UIControlState.normal)

            } else {
                
                titleButton.setTitle("Facebook", for: UIControlState.normal)
                titleButton.setImage(UIImage(named: "edit"), for: UIControlState.normal)

            }


        }
        
        let a = titleButton.titleLabel!.bounds.width
        let b = titleButton.imageView!.bounds.width
        
        print(a)
        print(b)
        
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(2, titleButton.titleLabel!.bounds.width, 0, -titleButton.titleLabel!.bounds.width)
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -titleButton.imageView!.bounds.width, 0, titleButton.imageView!.bounds.width)

    }
    
    func layoutCollectionView() {
        let layout = BouncyLayout()
        let cellWidth = (self.view.bounds.width - 10)/3
        let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
        
        layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        
        myCollectionView.collectionViewLayout = layout
        myCollectionView!.delegate = self
        myCollectionView!.dataSource = self
    }
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("--------")
        if !editModel {
            self.performSegue(withIdentifier: "myDetail", sender: self)
        } else {
            
        }
        
    }
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aaCollection", for: indexPath) as! CollectionViewCell
        
        

        if editModel {
            cell.selectButton.isHidden = false
            cell.myButton.isUserInteractionEnabled = true
        } else {
            cell.selectButton.isHidden = true
            cell.myButton.isUserInteractionEnabled = false
        }
        
        cell.selectButton.tag = indexPath.row
        cell.myButton.tag = indexPath.row
        cell.myButton.addTarget(self, action: #selector(self.editModelSelect(sender:)), for: UIControlEvents.touchUpInside)
        cell.selectButton.addTarget(self, action: #selector(self.editModelSelect(sender:)), for: UIControlEvents.touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func editModelSelect(sender: UIButton) {
        let cell = myCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! CollectionViewCell
        cell.selectButton.isSelected = !cell.selectButton.isSelected

        if cell.selectButton.isSelected {
            rightButton.tag += 1
        } else {
            rightButton.tag -= 1
        }
        print(rightButton.tag)

        reloadLeftButton()
    }


    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        if !editModel {
            self.navigationController?.popViewController(animated: true)
        } else if editModel && rightButton.tag == 0 {
            let title = "请选择图片"
            let message = "请选择要删除的图片~"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                
            }
            
            // Create second button
            let buttonTwo = DefaultButton(title: "确定") {
            }
            
            //修改下原来的确定颜色为黑色
            buttonTwo.defaultTitleColor = UIColor.black
            // Add buttons to dialog
            popup.addButtons([buttonTwo])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)

        } else if editModel && rightButton.tag != 0 {
            let title = "确认删除"
            let message = "删除之后将不能恢复\n确认删除选中的图片吗？"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                
            }
            
            // Create first button
            let buttonOne = CancelButton(title: "取消") {
                
            }
            
            // Create second button
            let buttonTwo = DefaultButton(title: "确定") {
                //删除选中的图片
                
            }
            
            //修改下原来的确定颜色为黑色
            buttonTwo.defaultTitleColor = UIColor.black
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)

        }
        
    }

    @IBAction func rightButtonDidTouch(_ sender: UIBarButtonItem) {
        if !editModel {
            rightButton.title = "取消"
            leftButton.title = "删除"
            leftButton.image = UIImage(named: "")
            
            editModel = true
            
            titleButton.isUserInteractionEnabled = false
            setTitleButton()
            
            reloadLeftButton()
            
        } else {
            rightButton.title = "管理"
            leftButton.title = ""
            leftButton.image = UIImage(named: "back")
            leftButton.tintColor = UIColor.black
            
            editModel = false
            
            titleButton.isUserInteractionEnabled = true
            setTitleButton()
            
        }
        
        myCollectionView.reloadData()
        
    }
    
    func reloadLeftButton() {
        if rightButton.tag == 0 {
            leftButton.tintColor = UIColor.red //UIColor(hex: "B9B9B9")

        } else {
            leftButton.tintColor = UIColor.black

        }
        
    }
    
    @IBAction func titleButtonDidTouch(_ sender: UIButton) {
        if type == 1 {
            self.performSegue(withIdentifier: "collectionApp", sender: self)
            
        } else {
            //出修改收藏的标题
            
        }
    }
    
}
