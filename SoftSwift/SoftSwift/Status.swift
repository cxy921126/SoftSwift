//
//  Statues.swift
//  SoftSwift
//
//  Created by  cxy on 16/3/17.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    ///新浪默认时间格式
    let default_form = NSDateFormatter()
    ///自定义的时间显示格式
    let screen_form = NSDateFormatter()
    var created_at : String?{
        didSet{
            default_form.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
            default_form.locale = NSLocale(localeIdentifier: "en")
            let defaultDate = default_form.dateFromString(created_at!)
            
            screen_form.dateFormat = "yy-MM-dd HH:mm"
            screen_form.locale = NSLocale(localeIdentifier: "en")
            let screenDate = screen_form.stringFromDate(defaultDate!)
            created_at = screenDate
        }
    }
    var id : Int = 0
    var text : String?
    
    var final_source : String?
    // MARK: 去除<>标签
    var source : String?{
        didSet{
            var str = source
            let scanner = NSScanner(string: source!)
            var text : NSString?
            while !scanner.atEnd {
                scanner.scanUpToString("<", intoString: nil)
                scanner.scanUpToString(">", intoString: &text)
                str = str!.stringByReplacingOccurrencesOfString("\(text!)>", withString: "")
            }
            final_source = str
        }
    }
    ///配图地址
    var pic_urls : [[String : AnyObject]]?
    
    var user : User?
    //转发微博的字典，根据该字典创建转发微博的Status模型
    var retweeted_status : [String:AnyObject]?{
        didSet{
            retweeted_weibo = Status(dic: retweeted_status!)
        }
    }
    var retweeted_weibo : Status?
    
    //转发评论点赞数
    var reposts_count: Int = 0
    var comments_count: Int = 0
    var attitudes_count: Int = 0
    
    init(dic: [String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    //重写此方法以免属性与字典的key不对应而出错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    //setValuesForKeysWithDictionary方法中总会调用此方法，重写以获取User模型
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "user"{
            user = User(dic: value as! [String:AnyObject])
        }
        if key == "retweeted_status" {
            //print(retweeted_weibo?.classForCoder)
        }
    }
    
    //MARK: - 下载微博数组
    class func loadStatuses(since_id:Int, max_id:Int, finished:(models:[Status])->()){
        let user = UserAccount.readAccount()
        var param = ["access_token" : user!.access_token]
        var models = [Status]()
        
        if since_id > 0 {
            param["since_id"] = "\(since_id)"
        }
        
        if max_id > 0 {
            param["max_id"] = "\(max_id-1)"
        }
        
        print(param)
        
        
        NetworkTool.sharedNetworkTool().GET("2/statuses/home_timeline.json", parameters: param, progress: nil, success: { (_, JSON) -> Void in
            
            //1.将JSON中的statuses数组取出来
            let statuses = JSON!["statuses"] as? [[String:AnyObject]]
            
            //2.将数组中的每个字典对应赋值给Status模型，并放入模型数组中
            for statusDic in statuses!{
                let status = Status(dic: statusDic)
                models.append(status)
            }
            
            //3.调用图片异步下载并缓存方法，当此方法结束时回调block-----block中调用finished传回models
            downloadImages(models, finished: { () -> () in
                finished(models: models)
            })
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
    
    class func downloadImages(models:[Status], finished:()->()){
        let group = dispatch_group_create()
        
        for model in models{
            
            if model.pic_urls == nil{
                continue
            }
            
            for urlDic in model.pic_urls!{
                //进入group
                dispatch_group_enter(group)
                let url = NSURL(string: urlDic["thumbnail_pic"] as! String)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    //print("---")
                    //下载完成后离开group
                    dispatch_group_leave(group)
                })
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            //print("over")
            finished()
        }
        
    }
    
    override var description: String {
        return "user is \(user)-------- text is \(text) -----------pic_urls is \(pic_urls)----------create_at \(created_at)"
    }
}
