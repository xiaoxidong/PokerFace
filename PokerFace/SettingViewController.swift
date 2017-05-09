//
//  SettingViewController.swift
//  PokerFace
//
//  Created by xiaodong on 28/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: BasicViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var iconImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImage.layer.cornerRadius = 10
    }
    
    func setMailFeedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("PokerFace 意见反馈")
            //设置收件人
            controller.setToRecipients(["mua@productPoke.com"])
            
            //添加图片附件
//            let path = Bundle.main.path(forResource: "hangge.png", ofType: "")
//            let url = URL(fileURLWithPath: path!)
//            let myData = try! Data(contentsOf: url)
//            controller.addAttachmentData(myData, mimeType: "image/png", fileName: "swift.png")
            
            //设置邮件正文内容（支持html）
            controller.setMessageBody("", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            print("本设备不能发送邮件")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result{
        case .sent:
            print("邮件已发送")
        case .cancelled:
            print("邮件已取消")
        case .saved:
            print("邮件已保存")
        case .failed:
            print("邮件发送失败")
        }
    }

    @IBAction func backButtonDidTouch(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func recommendButtonDidTouch(_ sender: UIButton) {
        self.performSegue(withIdentifier: "poke", sender: self)
        
    }

    @IBAction func adviceButtonDidTouch(_ sender: UIButton) {
        setMailFeedback()
        
    }

    @IBAction func tellFriendButtonDidTouch(_ sender: UIButton) {
        print("------分享给好友------")
        
    }

    @IBAction func commentButtonDidTouch(_ sender: UIButton) {
        let urlString = "https://itunes.apple.com/us/app/airbnb/id401626263?mt=8"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }

    @IBAction func logOutButtonDidTouch(_ sender: UIButton) {
        print("------------")
        
    }


}
