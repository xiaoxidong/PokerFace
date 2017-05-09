//
//  HomeCollectionViewCell.swift
//  PokerFace
//
//  Created by xiaodong on 25/04/2017.
//  Copyright © 2017 xiaodong. All rights reserved.
//

import UIKit

protocol TapCellDelegate:NSObjectProtocol{
    func buttonTapped(indexPath:IndexPath)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate:TapCellDelegate?
    
    
    
    
}
