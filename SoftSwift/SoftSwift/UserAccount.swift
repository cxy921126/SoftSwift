//
//  UserAccount.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/14.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

///用户数据模型
class UserAccount: NSObject, NSCoding {
    var access_token : String = ""
    var expires_in : NSNumber = 0
    var remind_in : String = ""
    var uid : String = ""
    var avatar_large : String = ""
    
    init(dic : [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    //MARK: - 重写print类对象时所输出的内容
    override var description : String{
        return ("access_token = \(access_token), expires_in = \(expires_in), uid = \(uid), avatar_large = \(avatar_large)")
    }
    
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: "user.plist".cachesDir())
    }
 
    class func readAccount() -> UserAccount?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile("user.plist".cachesDir()) as? UserAccount
    }
    
    //MARK: - 实现NSCoding方法
    
    //MARK: 为NSKeyedArchiver设置编码格式
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(remind_in, forKey: "remind_in")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    //MARK: 为NSKeyedUnarchiver设置解码格式，返回到类属性
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as! String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as! NSNumber
        remind_in = aDecoder.decodeObjectForKey("remind_in") as! String
        uid = aDecoder.decodeObjectForKey("uid") as! String
    }
    
}
