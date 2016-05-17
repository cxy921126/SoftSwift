//
//  unloginView.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/5.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

protocol UnloginViewDelegate : NSObjectProtocol{
    func presentSignUp()
    func presentLogin()
}

class UnloginView: UIView {
    weak var delegate : UnloginViewDelegate?
    
    @IBOutlet weak var titleImageTopMargin: NSLayoutConstraint!
    @IBOutlet weak var titleImageBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rotateImage: UIImageView!
    
    @IBAction func goSignUp(sender: AnyObject) {
        delegate?.presentSignUp()
    }
    @IBAction func goLogin(sender: AnyObject) {
        delegate?.presentLogin()
    }

    
    override func awakeFromNib() {
        descriptionLabel.numberOfLines = 0
        signUpBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
    }

}
