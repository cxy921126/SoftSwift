//
//  User.swift
//  SoftSwift
//
//  Created by  cxy on 16/3/18.
//  Copyright © 2016年 XMU. All rights reserved.
//

//access_token = 2.00yvLITCHb6tXE0c42e9e449ZJV_CE
import UIKit

class User: NSObject {
    var id : Int = 0
    var name : String?
    var profile_image_url : String?
    var verified : Bool?
    var verified_type : Int = 0
    
    init(dic:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description:String {
        return "\(id)\n\(name)\n\(profile_image_url)"
    }
}
