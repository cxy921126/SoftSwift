//
//  LearnViewCell.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/13.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class LearnCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var natatoriumLabel: UILabel!
    @IBOutlet weak var expectedTimeLabel: UILabel!
    @IBOutlet weak var natatoriumCons: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        natatoriumCons.constant = screenWidth - 120
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        nickNameLabel.sizeToFit()
    }

}
