//
//  LearnViewCell.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/13.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class LearnCell: UITableViewCell {
    @IBOutlet weak var nickNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        nickNameLabel.sizeToFit()
    }

}
