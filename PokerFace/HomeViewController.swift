//
//  HomeViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import BouncyLayout
//import Sparrow
import Photos
import BubbleTransition
import ReachabilitySwift
import EasyPull
import DGElasticPullToRefresh
import ELWaterFallLayout
import DeviceKit
import Alamofire

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoPickerControllerDelegate, UIViewControllerTransitioningDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    var array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    var newArray = ["10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "17"]
    
    var selectViewIsOn = false
    let selectView: SelectView = Bundle.main.loadNibNamed("SelectView", owner: self, options: nil)?.first as! SelectView

    let kCellId = "home"
    var hideStatusBar = true
    var homeLayout = 3
    
    var homeSelectedImages = [PHAsset]()
    
    let transition = BubbleTransition()
    
    var page = 1
    var collectionType = 0
    
    var hideHomeStatusBar = false
    
    //let permissins: [SPRequestPermissionType] = [.photoLibrary]
    
    var newLayout = UICollectionViewFlowLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutCollectionView()
        addSearchButton()
        layoutLayer()
        
        let net = Network()
        //net.requestData()
        
        //let banner = NotificationBanner(title: "Basic Warning Notification", subtitle: "Custom Warning Color", style: .warning, colors: CustomBannerColors())
        
        //banner.show()
        
        let device = Device()
        if device == .iPhone7Plus {
            //print("--------------------====================")
        }
        
        if device.isPhone {
            
        }
        
        let groupOfAllowedDevices: [Device] = [.iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .simulator(.iPhone6), .simulator(.iPhone6Plus), .simulator(.iPhone6s), .simulator(.iPhone6sPlus)]
        
        if device.isOneOf(groupOfAllowedDevices) {
            // Do you action
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.all
        
        
        
        let parameters = ["Usrid": 1]
        
        Alamofire.request("http://182.92.153.114:8088/pubblic/getImages", method: .post, parameters: parameters).responseJSON { (json) in
            print(json)
        }
        
    }
    
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(named: "navigationImage")
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        pullToRefresh()
        loadMore()
        
    }
    
     //滑动的时候隐藏导航栏和状态栏
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
         let pan = scrollView.panGestureRecognizer
         let velocity = pan.velocity(in: scrollView).y
         if velocity < -5 {
            if homeCollectionView.contentOffset.y > 70 {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.hideHomeStatusBar = true
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
             
             searchButton.frame.origin.y = self.view.bounds.height
         
         
         } else if velocity > 1000 {
             self.navigationController?.setNavigationBarHidden(false, animated: true)
             hideHomeStatusBar = false
             self.setNeedsStatusBarAppearanceUpdate()
         
         }
     
     }
     
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
         self.perform(#selector(self.didiEndScroll), with: nil, afterDelay: 3)
     
     }
     
     func didiEndScroll() {
         NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(didiEndScroll), object: nil)
        
        self.hideHomeStatusBar = false
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
     }
     
     override var prefersStatusBarHidden: Bool {
         return hideHomeStatusBar
     }
    
    //下拉加载更多数据
    func loadMore() {
        homeCollectionView.easy.addUpPullAutomatic(with: {
            self.delayStopDrop()
            
        })
    }
    
    //请求数据之后停止刷新
    func delayStopDrop() {
        //请求数据
        
        //合并数据
        array = array + newArray
        page += 1
        
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.homeCollectionView.reloadData()
            self.homeCollectionView.easy.stopUpPull()
        }
    }
    
    //下拉刷新事件
    func pullToRefresh() {
        //navigationController?.navigationBar.shadowImage = UIImage()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.black//(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        
        homeCollectionView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self?.homeCollectionView.dg_stopLoading()
                //self?.navigationController?.navigationBar.shadowImage = UIImage(named: "navigationImage")
                
                //加载数据
                self?.page = 1
                
            })
            }, loadingView: loadingView)
        
        homeCollectionView.dg_setPullToRefreshFillColor(UIColor.white)
        homeCollectionView.dg_setPullToRefreshBackgroundColor(homeCollectionView.backgroundColor!)
        
    }
    
    deinit {
        homeCollectionView.dg_removePullToRefresh()
    }
    
    //初始化 CollectionView
    func layoutCollectionView() {
        if collectionType == 0 {
            //iPhone 选项
            let layout = UICollectionViewFlowLayout() //BouncyLayout()
            let cellWidth = (self.view.bounds.width - 4)/3
            let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
            
            layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
            //列间距,行间距,偏移
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 2
            layout.sectionInset = UIEdgeInsetsMake(6, 0, 0, 0)
            
            homeCollectionView.collectionViewLayout = layout
            
        } else if collectionType == 1 {
            //iPad 选项
            let layout = BouncyLayout()
            let cellWidth = (self.view.bounds.width - 5)/2
            let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
            
            layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
            //列间距,行间距,偏移
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsetsMake(6, 0, 0, 0)
            
            homeCollectionView.collectionViewLayout = layout

        } else if collectionType == 2 {
            //All 选项
            
        }
        
        homeCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        homeCollectionView!.delegate = self
        homeCollectionView!.dataSource = self
    }
    
    //初始化下拉筛选
    func layoutLayer() {
        //初始化下拉选择，添加事件
        selectView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
        selectView.layer.shadowColor = UIColor.black.cgColor
        selectView.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectView.layer.shadowOpacity = 0.1
        
        //分类点击事件
        selectView.iPhoneButton.addTarget(self, action: #selector(self.iPhoneButtonDidTouch), for: UIControlEvents.touchUpInside)
        selectView.iPadButton.addTarget(self, action: #selector(self.iPadButtonDidTouch), for: UIControlEvents.touchUpInside)
        selectView.allButton.addTarget(self, action: #selector(self.allButtonDidTouch), for: UIControlEvents.touchUpInside)
        
        //点击其他位置的时候也收起下拉
        let windowGesture = UITapGestureRecognizer(target: self, action: #selector(self.showOrHideSelectView))
        selectView.addGestureRecognizer(windowGesture)
    }
    
    //设置搜索按钮的属性
    func addSearchButton() {
        searchButton.layer.cornerRadius = 20
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchButton.layer.shadowOpacity = 0.3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.hideStatusBar = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击跳转到详情页
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = CGFloat()
        var cellHeight = CGFloat()
        
        if collectionType == 0 {
            //iPhone
            if homeLayout == 3 {
                //3列
                cellWidth = (self.view.bounds.width - 10)/3
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            } else if homeLayout == 2 {
                //2列
                cellWidth = (self.view.bounds.width - 5)/2
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            } else {
                //1列
                cellWidth = self.view.bounds.width
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            }
        } else if collectionType == 1 {
            //iPad
            if homeLayout == 3 {
                //3列
                cellWidth = (self.view.bounds.width - 10)/3
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            } else if homeLayout == 2 {
                //2列
                cellWidth = (self.view.bounds.width - 5)/2
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            } else {
                //1列
                cellWidth = self.view.bounds.width
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            }
            
        } else {
            //All
            if homeLayout == 3 {
                //3列
                cellWidth = (self.view.bounds.width - 10)/3
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            } else if homeLayout == 2 {
                //2列
                cellWidth = (self.view.bounds.width - 5)/2
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            } else {
                //1列
                cellWidth = self.view.bounds.width
                cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
                
            }
        }
        
        return CGSize(width:cellWidth, height:cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5.0
    }
    */
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! HomeCollectionViewCell
        
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.cellDoubleTap))
//        doubleTap.numberOfTapsRequired = 2
//        cell.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.cellSingleTap))
        singleTap.numberOfTapsRequired = 1
        cell.addGestureRecognizer(singleTap)
        
        //singleTap.require(toFail: doubleTap)
        
        cell.imageView.contentMode = UIViewContentMode.top
        cell.imageView.contentMode = UIViewContentMode.scaleAspectFill
        cell.imageView.image = UIImage(named: array[indexPath.row])
        
        return cell
    }
    
    
    
    func cellDoubleTap() {

//        if homeLayout == 3 {
//            homeLayout = 2
//        } else if homeLayout == 2 {
//            homeLayout = 1
//        } else {
//            homeLayout = 3
//        }
        
//        if homeCollectionView.contentOffset.y < self.view.bounds.height {
//            homeCollectionView.contentOffset.y = self.view.bounds.height * 2
//        }
       // homeCollectionView.reloadSections([0])
        //homeCollectionView.reloadData()
        //homeCollectionView.contentOffset.y = 0
        //homeCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0), IndexPath(item: 3, section: 0), IndexPath(item: 4, section: 0), IndexPath(item: 5, section: 0), IndexPath(item: 6, section: 0), IndexPath(item: 7, section: 0), IndexPath(item: 8, section: 0)])
        
        
        
        if homeLayout == 3 {
            let layout = UICollectionViewFlowLayout()
            let cellWidth = (self.view.bounds.width - 5)/2
            let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width
            layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
            //列间距,行间距,偏移
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)

            
            UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.homeCollectionView.collectionViewLayout = layout
                self.homeCollectionView.reloadData()
            }, completion: nil)
            
            homeLayout = 2
        }else if homeLayout == 2 {
            let layout = UICollectionViewFlowLayout()
            let cellWidth = self.view.bounds.width
            let cellHeight = self.view.bounds.height
            
            layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
            //列间距,行间距,偏移
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
            
            UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.homeCollectionView.collectionViewLayout = layout
                self.homeCollectionView.reloadData()
            }, completion: nil)
            
            homeLayout = 1
        }else {
            let layout = UICollectionViewFlowLayout()
            let cellWidth = (self.view.bounds.width - 10)/3
            let cellHeight = cellWidth * self.view.bounds.height / self.view.bounds.width

            layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
            //列间距,行间距,偏移
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
            
            UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.homeCollectionView.collectionViewLayout = layout
                self.homeCollectionView.reloadData()
            }, completion: nil)
            
            homeLayout = 3
            
        }
        
        
    }
    
    func cellSingleTap() {
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    //iPhone 截图选项
    func iPhoneButtonDidTouch() {
        selectView.iPhoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0.3)
        selectView.iPadButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0)
        selectView.allButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0)

        showOrHideSelectView()
        
        //修改页面布局
        
    }
    
    //iPad 截图选项
    func iPadButtonDidTouch() {
        selectView.iPadButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0.3)
        selectView.allButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0)
        selectView.iPhoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0)

        showOrHideSelectView()
        
        //修改页面布局
    }
    
    //所有截图选项
    func allButtonDidTouch() {
        selectView.allButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0.3)
        selectView.iPadButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0)
        selectView.iPhoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: 0)

        showOrHideSelectView()
        
        //修改页面布局
    }
    
    
    //下拉显示和隐藏
    func showOrHideSelectView() {
        if !selectViewIsOn {
            UIApplication.shared.keyWindow?.addSubview(selectView)
            UIApplication.shared.keyWindow!.inputView?.backgroundColor = UIColor.purple
            titleButton.setImage((UIImage (named: "indicatorup")), for: UIControlState.normal)
            
        } else {
            selectView.removeFromSuperview()
            titleButton.setImage((UIImage (named: "indicator")), for: UIControlState.normal)
        }
        
        selectViewIsOn = !selectViewIsOn
    }

    //登录按钮事件
    @IBAction func loginButtonDidTouch(_ sender: UIBarButtonItem) {
        if selectViewIsOn {
            showOrHideSelectView()
        }
        
        self.performSegue(withIdentifier: "self", sender: self)
        
    }
    
    //上传按钮事件
    @IBAction func uploadButtonDidTouch(_ sender: UIBarButtonItem) {
        if selectViewIsOn {
            showOrHideSelectView()
        }
        
        //获取相册权限
//        if !SPRequestPermission.isAllowPermission(.photoLibrary) {
//            SPRequestPermission.dialog.interactive.present(on: self, with: [.photoLibrary])
//        }
        
        //选择图片
        let picker = PhotoPickerController(type: PageType.Screenshots)
        picker.imageSelectDelegate = self
        picker.modalPresentationStyle = .popover
        
        // max select number
        PhotoPickerController.imageMaxSelectedNum = 10
        
        self.show(picker, sender: nil)
        
    }
    
    //选择完图片之后的代理实现
    func onImageSelectFinished(images: [PHAsset]) {
        homeSelectedImages = images

        //选择图片之后加载图片编辑页面
        self.performSegue(withIdentifier: "photo", sender: self)
        
        //获取到图片
        self.renderSelectImages(images: images)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photo" {
            let vc = segue.destination  as! PhotoViewController
            vc.selectedImages = homeSelectedImages
            
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
        }
        
        
    }

    //点击上传之后的事件
    private func renderSelectImages(images: [PHAsset]){
//        for item in images {
//            self.selectModel.insert(PhotoImageModel(type: ModelType.Image, data: item), at: 0)
//        }
//        
//        let total = self.selectModel.count;
//        if total > PhotoPickerController.imageMaxSelectedNum {
//            for i in 0 ..< total {
//                let item = self.selectModel[i]
//                if item.type == .Button {
//                    self.selectModel.remove(at: i)
//                    
//                }
//            }
//        }
//        self.renderView()
    }
    
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismiss(animated: true, completion: nil)
        

        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    //搜索按钮事件
    @IBAction func searchButtonDidTouch(_ sender: UIButton) {
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    //标题点击下拉事件
    @IBAction func titleViewDidTouch(_ sender: UIButton) {
        showOrHideSelectView()
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: 100, y: 100)//someButton.center
        //transition.bubbleColor = someButton.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint =  CGPoint(x: 100, y: 100)//someButton.center
        //transition.bubbleColor = someButton.backgroundColor!
        return transition
    }
}

