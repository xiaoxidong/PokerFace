//
//  SelectPhotoCollectionViewCell.swift
//  PokerFace
//
//  Created by xiaodong on 27/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

class SelectPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectButton: UIButton!
    
    //图片选中和取消选中设置
    @IBAction func slectButtonDidTouch(_ sender: UIButton) {
        if selectButton.tag == 100 {
            selectButton.setImage(UIImage(named: "picture_select"), for: UIControlState.normal)
            selectButton.tag = 101
            
        }else {
            selectButton.setImage(UIImage(named: "picture_unselect"), for: UIControlState.normal)
            selectButton.tag = 100
        }
    }
}
