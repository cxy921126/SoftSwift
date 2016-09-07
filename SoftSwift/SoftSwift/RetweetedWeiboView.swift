//
//  RetweetedWeiboView.swift
//  SoftSwift
//
//  Created by Mac mini on 16/4/16.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class RetweetedWeiboView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    var status : Status?{
        didSet{
            layoutSubviews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function)
        nameLabel.text = status?.user?.name
        textLabel.text = status?.text
        createTimeLabel.text = status?.created_at
        print("\(nameLabel.text)------\(textLabel.text)")
    }
    
//    override func setNeedsDisplay() {
//        super.setNeedsDisplay()
//        nameLabel.text = status?.user?.name
//        textLabel.text = status?.text
//        createTimeLabel.text = status?.created_at
//        print(#function)
//        print("\(nameLabel.text)------\(textLabel.text)")
//    }
}
