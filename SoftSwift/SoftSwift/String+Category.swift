//
//  String+Category.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/14.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

extension String{
    func cachesDir() -> String{
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return dir.stringByAppendingPathComponent(self)
    }
    
    func documentDir() -> String{
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return dir.stringByAppendingPathComponent(self)
    }
    
    func tmpDir() -> String{
        let dir = NSTemporaryDirectory() as NSString
        return dir.stringByAppendingPathComponent(self)
    }
}
