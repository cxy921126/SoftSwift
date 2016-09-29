//
//  userAvatarHeader.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/20.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class userAvatarHeader: UIView {
    @IBOutlet weak var backGroundView: UIImageView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var genderView: UIImageView!
    @IBOutlet weak var personalityLabel: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.clipsToBounds = true
        avatarView.layer.cornerRadius = 30
        avatarView.clipsToBounds = true
    }
}
