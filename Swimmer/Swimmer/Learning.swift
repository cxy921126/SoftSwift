//
//  Learning.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/19.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class Learning: NSObject {
    ///头像图片地址
    var learnId: Int?
    var natatorium: String?
    var expectedTime: String?
    var user: User?
    var learningDescription: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        return "\(learnId)--------\(natatorium) ------\(expectedTime)"
    }

}
