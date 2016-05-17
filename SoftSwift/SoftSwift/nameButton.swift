//
//  nameButton.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/6.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class nameButton: UIButton{

     override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.width)!
    }

}
