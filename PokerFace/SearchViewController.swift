//
//  SearchViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import BouncyLayout

class SearchViewController: BasicViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var appCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    @IBOutlet weak var searchResultConstraint: NSLayoutConstraint!
    
    let appCellId = "appCell"
    let categoryCellId = "categoryCell"
    let searchResultCellId = "searchResult"

    override func viewDidLoad() {
        super.viewDidLoad()

        //隐藏系统自带的返回按钮
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        searchTextField.becomeFirstResponder()
        searchTextField.tintColor = UIColor.black
        searchTextField.delegate = self
        
        layoutAppCollectionView()
        layoutCategoryCollectionView()
        layoutSearchResultCollectionView()
        
        //设置下 APP 左侧的偏移量，第二个方法却不可以，为什么？
        appCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 0)

        searchResultConstraint.constant = self.view.bounds.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    
    @IBAction func cancelButtonDidTouch(_ sender: UIBarButtonItem) {
        //点击取消按钮的时候先移除键盘在返回
        searchTextField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //初始化 CollectionView
    func layoutAppCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:60, height:80)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 10
       // layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        appCollectionView.collectionViewLayout = layout
        appCollectionView!.delegate = self
        appCollectionView!.dataSource = self
        
    }
    
    func layoutCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:self.view.bounds.width, height:40)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView!.delegate = self
        categoryCollectionView!.dataSource = self
    }
    
    //初始化 CollectionView
    func layoutSearchResultCollectionView() {
        let layout = BouncyLayout()
        let cellWidth = (self.view.bounds.width - 10)/3
        let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
        
        layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        
        searchResultCollectionView.collectionViewLayout = layout
        searchResultCollectionView!.delegate = self
        searchResultCollectionView!.dataSource = self
    }
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击跳转到详情页
        
    }
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "app" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appCellId, for: indexPath) as! AppCollectionViewCell
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.appDidTouch))
            cell.iconButton.addGestureRecognizer(tapGesture)
            
            return cell
        }else if collectionView.restorationIdentifier == "category" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as!CategoryCollectionViewCell
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.categoryDidTouch))
            cell.categoryButton.addGestureRecognizer(tapGesture)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchResultCellId, for: indexPath) as!SearchResultCollectionViewCell
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.searchResultDidTouch))
            cell.searchResultButton.addGestureRecognizer(tapGesture)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
    
    //应用被点击
    func appDidTouch() {
        self.performSegue(withIdentifier: "searchApp", sender: self)
        
    }
    
    //类别被点击
    func categoryDidTouch() {
        searchTextField.text = "2222"
        searchTextField.resignFirstResponder()
        
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.searchResultCollectionView.isHidden = false
            self.searchResultConstraint.constant = 0
            self.searchResultCollectionView.reloadData()
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    func searchResultDidTouch() {
        self.performSegue(withIdentifier: "searchDetail", sender: self)
    }
    
    //当删除最后一个输入框的内容的时候隐藏搜索结果
    func textFieldDidChange() {
        if searchTextField.text == "" {
            self.searchResultConstraint.constant = self.view.bounds.height
            
        }
    }


}
