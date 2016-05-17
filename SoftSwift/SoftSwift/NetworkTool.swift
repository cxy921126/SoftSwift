//
//  NetworkTool.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/10.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTool: AFHTTPSessionManager {
    //必须用static修饰
    static let tools : NetworkTool = {
        let url = NSURL(string: "https://api.weibo.com/")
        let tool = NetworkTool(baseURL: url)
        tool.responseSerializer.acceptableContentTypes = NSSet(set: ["application/json", "text/json", "text/javascript","text/plain"]) as? Set
        return tool
    }()
    
    class func sharedNetworkTool() -> NetworkTool{
        return tools
    }
}
