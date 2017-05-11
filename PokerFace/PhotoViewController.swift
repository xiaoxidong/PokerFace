//
//  PhotoViewController.swift
//  PokerFace
//
//  Created by xiaodong on 06/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import PopupDialog
import Photos
import ReachabilitySwift
import TagListView

class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, TagListViewDelegate {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    var selectedImages = [PHAsset]()
    var selectModel = [PhotoImageModel]()
    
    let kCellId = "photoCell"
    
    var keyBoardHeight: CGFloat = 0
    var showOrHideView = false
    
    var showOrHideNameView = false
    var showOrHideCategoryView = false
    
    var tagNames = ["北京", "内蒙古自治区", "摩洛哥", "吃饭", "西安", "拉斐尔", "湖北", "Newyork", "洛杉矶", "拉萨", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓哈哈哈东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东", "晓东"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "上传(\(Int(photoCollectionView.contentOffset.x/self.view.bounds.width) + 1)/\(selectedImages.count))"
        if selectedImages.count == 1 {
            rightButton.title = "上传"
        }

        renderSelectImages(images: selectedImages)
        
        layoutCollectionView()
        
        nameTextField.delegate = self
        categoryTextField.delegate = self
        
        nameTextField.tag = 100
        categoryTextField.tag = 101
        
        nameTextField.tintColor = UIColor.black
        categoryTextField.tintColor = UIColor.black

        //设置光标偏移
        let nameLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        nameTextField.leftView = nameLeftView
        nameTextField.leftViewMode = UITextFieldViewMode.always
        
        let categoryLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        categoryTextField.leftView = categoryLeftView
        categoryTextField.leftViewMode = UITextFieldViewMode.always
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notice:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notice:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChangeFrame(notice:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        tagScrollView.contentSize = CGSize(width: self.view.bounds.width * 2, height: 140)
        tagScrollView.showsHorizontalScrollIndicator = false
        
        //初始化tag
        self.setTagView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //nameTextField.becomeFirstResponder()
    }
    
    func setTagView() {
        
        let tagView = TagListView()
        tagView.frame = CGRect(x: 10, y: 10, width: self.view.bounds.width * 2 - 20, height: 120)
        tagView.marginX = 14
        tagView.marginY = 14
        tagView.paddingX = 10
        tagView.paddingY = 10
        tagView.cornerRadius = 16
        
        tagView.delegate = self
        
        for tag in tagNames {
            
            tagView.addTag(tag)
            
        }
        
        for singleTagView in tagView.tagViews {
            singleTagView.backgroundColor = self.randomColor()
        }
        
        tagScrollView.addSubview(tagView)
    }
    
    //某个 Tag 被点击
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        //sender.removeTag(title)
        
        if !(categoryTextField.text?.contains(title))! {
            if (categoryTextField.text?.isEmpty)! || categoryTextField.text?.characters.last == "," || categoryTextField.text?.characters.last == "，" {
                categoryTextField.text = categoryTextField.text! + "\(title)"
            } else {
                categoryTextField.text = categoryTextField.text! + "，\(title)"
            }
            
        }
    }
    
    //显示和隐藏 tagView
    func showOrHideTagView() {
        if showOrHideCategoryView {
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.tagScrollView.layer.opacity = 1
                
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.tagScrollView.layer.opacity = 0
                
            }, completion: nil)
        }
        
    }
    
    //显示和隐藏 Name
    func showOrHideNameTableView() {
        if showOrHideNameView {
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                //self.tagScrollView.layer.opacity = 1
                
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                //self.tagScrollView.layer.opacity = 0
                
            }, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 100 {
            //name 输入框被激活
            showOrHideCategoryView = false
            self.showOrHideTagView()
            
            showOrHideNameView = true
            self.showOrHideNameTableView()
        } else if textField.tag == 101 {
            //分类输入框被激活
            showOrHideNameView = false
            self.showOrHideNameTableView()
            
            showOrHideCategoryView = true
            self.showOrHideTagView()
        }
    }
    
    func keyboardWillShow(notice : NSNotification) {
        let userInfo = notice.userInfo as NSDictionary!
        
        let aValue = userInfo!.object(forKey: UIKeyboardFrameEndUserInfoKey)
        
        let keyboardRect = (aValue as AnyObject).cgRectValue
        
        //键盘的高度
        keyBoardHeight = keyboardRect!.size.height
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            
            if self.keyBoardHeight > 0 {
                //self.toolBarView.frame.origin.y = self.view.bounds.height - self.keyBoardHeight - 50
                self.bottomLayoutConstraint.constant = self.keyBoardHeight
                self.view.layoutIfNeeded()
                
            }
            
        }, completion: nil)
    }
    
    func keyboardWillHide(notice : NSNotification) {
        bottomLayoutConstraint.constant = 0

        showOrHideNameView = false
        self.showOrHideNameTableView()
        
        showOrHideCategoryView = false
        self.showOrHideTagView()
        
    }
    
    func keyboardChangeFrame(notice : NSNotification) {
        let userInfo = notice.userInfo as NSDictionary!
        
        let aValue = userInfo!.object(forKey: UIKeyboardFrameEndUserInfoKey)
        
        let keyboardRect = (aValue as AnyObject).cgRectValue
        
        //键盘的高度
        keyBoardHeight = keyboardRect!.size.height
    }
    
    //初始化 CollectionView
    func layoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = self.view.bounds.width
        let cellHeight = self.view.bounds.height
        
        layout.itemSize = CGSize(width:cellWidth, height:cellHeight)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        photoCollectionView.collectionViewLayout = layout
        photoCollectionView!.delegate = self
        photoCollectionView!.dataSource = self
        photoCollectionView.isPagingEnabled = true
    }

    @IBAction func closeButtonDidTouch(_ sender: UIBarButtonItem) {
        let title = "取消截图上传"
        let message = "取消后添加的内容将消失在地球上:（ \n真的取消上传吗？"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {

        }

        // Create first button
        let buttonOne = CancelButton(title: "取消") {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "确定") {
            self.navigationController?.popViewController(animated: true)
        }
        
        //修改下原来的确定颜色为黑色
        buttonTwo.defaultTitleColor = UIColor.black
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
    
    //MARK :- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击跳转到详情页
        
    }
    
    //MARK :- UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath)
        cell.tag = indexPath.row
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor.purple
        }else {
            cell.backgroundColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //滑动的时候设置标题，最后一张的时候设置右侧按钮为上传
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.title = "上传(\(Int(photoCollectionView.contentOffset.x/self.view.bounds.width) + 1)/\(selectedImages.count))"
        
        if Int(photoCollectionView.contentOffset.x/self.view.bounds.width) + 1 == selectedImages.count {
            rightButton.title = "上传"
        }else {
            rightButton.title = "下一张"
        }

    }
    
    private func renderView(){
        
        if selectModel.count <= 0 {return;}
        
        //PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixSize, height: pixSize)
        //PHImageManager.default().requestImage(for: selectedImages, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(UIImage?, [AnyHashable : Any]?) -> Void#>)
        
//        let totalWidth = UIScreen.main.bounds.width
//        let space:CGFloat = 10
//        let lineImageTotal = 4
//        
//        let line = self.selectModel.count / lineImageTotal
//        let lastItems = self.selectModel.count % lineImageTotal
//        
//        let lessItemWidth = (totalWidth - (CGFloat(lineImageTotal) + 1) * space)
//        let itemWidth = lessItemWidth / CGFloat(lineImageTotal)
        
        /*
        for i in 0 ..< line {
            let itemY = CGFloat(i+1) * space + CGFloat(i) * itemWidth
            for j in 0 ..< lineImageTotal {
                let itemX = CGFloat(j+1) * space + CGFloat(j) * itemWidth
                let index = i * lineImageTotal + j
                self.renderItemView(itemX: itemX, itemY: itemY, itemWidth: itemWidth, index: index)
            }
        }
        
        // last line
        for i in 0..<lastItems{
            let itemX = CGFloat(i+1) * space + CGFloat(i) * itemWidth
            let itemY = CGFloat(line+1) * space + CGFloat(line) * itemWidth
            let index = line * lineImageTotal + i
            self.renderItemView(itemX: itemX, itemY: itemY, itemWidth: itemWidth, index: index)
        }
        
        let totalLine = ceil(Double(self.selectModel.count) / Double(lineImageTotal))
        let containerHeight = CGFloat(totalLine) * itemWidth + (CGFloat(totalLine) + 1) *  space
        self.containerView.frame = CGRect(x:0, y:0, width:totalWidth,  height:containerHeight)
 
 */
    }
    
    
    private func renderSelectImages(images: [PHAsset]){
        for item in images {
            self.selectModel.insert(PhotoImageModel(type: ModelType.Image, data: item), at: 0)
        }
        
        let total = self.selectModel.count;
        if total > PhotoPickerController.imageMaxSelectedNum {
            for i in 0 ..< total {
                let item = self.selectModel[i]
                if item.type == .Button {
                    self.selectModel.remove(at: i)
                    
                }
            }
        }
        self.renderView()
    }

    //右侧按钮点击事件
    @IBAction func rightButtonDidTouch(_ sender: UIBarButtonItem) {
        if rightButton.title == "下一张" {
            photoCollectionView.contentOffset.x += self.view.bounds.width
            
        }else {
            checkNet()
            
        }
        
    }
    
    @IBAction func categoryButtonDidTouch(_ sender: UIButton) {
        if selectedImages.count > 0 {
            nameTextField.resignFirstResponder()
            categoryTextField.resignFirstResponder()
            
            self.performSegue(withIdentifier: "select", sender: self)
        }else {
            let title = "拼图提示"
            let message = "好像只有一张截图，是不可以拼图的哦"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                
            }
            
            // Create first button
            let buttonOne = CancelButton(title: "好的") {
                
            }
            
            popup.addButtons([buttonOne])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    //上传前检查网络
    func checkNet() {
        //declare this property where it won't go out of scope relative to your listener
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    self.uploadImages()
                    
                } else {
                    let title = "蜂窝网络上传"
                    let message = "现在处于蜂窝网络，上传将消耗一定流量\n确定继续上传吗？"
                    
                    // Create the dialog
                    let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                        
                    }
                    
                    // Create first button
                    let buttonOne = CancelButton(title: "取消") {
                        
                    }
                    
                    // Create second button
                    let buttonTwo = DefaultButton(title: "确定") {
                        self.uploadImages()
                        
                    }
                    
                    //修改下原来的确定颜色为黑色
                    buttonTwo.defaultTitleColor = UIColor.black
                    // Add buttons to dialog
                    popup.addButtons([buttonOne, buttonTwo])
                    
                    // Present dialog
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                let banner = NotificationBanner(title: "无网络连接",
                                                subtitle: "似乎没有网络连接，请检查",
                                                style: .warning,
                                                colors: CustomBannerColors())
                
                banner.show()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
    
 

    
    //图片上传服务器
    func uploadImages() {
        print("来上传图片吧")
        
    }
    
    //MARK: - 产生随机色
    func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/256.0, green: CGFloat(arc4random_uniform(128))/256.0+0.5, blue: CGFloat(arc4random_uniform(128))/256.0+0.5, alpha: 1)
    }

}
