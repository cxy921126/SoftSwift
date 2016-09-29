//
//  User.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/21.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class User: NSObject {
    var ID: Int?
    var avatarAddress: String?
    var nickName: String?
    var gender: String?
    var personalDescription: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
