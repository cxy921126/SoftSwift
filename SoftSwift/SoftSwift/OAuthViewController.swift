//
//  OAuthViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/10.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import MBProgressHUD

class OAuthViewController: UIViewController {
    let client_id = "4165356857"
    let client_secret = "6a7f0f4b1e81c251cd56c3f45e1156f7"
    let redirect_uri = "http://www.baidu.com"
    
    var code = ""
    var access_token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(webView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OAuthViewController.close))
        // Do any additional setup after loading the view.
    }
    
    lazy var webView : UIWebView = {
        let webView = UIWebView()
        webView.frame = UIScreen.mainScreen().bounds
        let authorize_url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(self.client_id)&redirect_uri=\(self.redirect_uri)")
        let request = NSURLRequest(URL: authorize_url!)
        webView.loadRequest(request)
        webView.delegate = self
        return webView
    }()
    
    lazy var netTool : NetworkTool = {
        let netTool = NetworkTool.sharedNetworkTool()
        return netTool
    }()
    
    //MARK: - 关闭登录界面
    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 获取access_token
    func getAccessToken(){
        let paramDic = [
            "client_id":client_id,
            "client_secret":client_secret,
            "grant_type":"authorization_code",
            "code":code,
            "redirect_uri":redirect_uri]
        
        netTool.POST("oauth2/access_token", parameters: paramDic, progress: nil, success: { (_, JSON) -> Void in
            self.access_token = JSON!["access_token"] as! String
            let user = UserAccount(dic: JSON as! [String:AnyObject])
            user.saveAccount()
            NSNotificationCenter.defaultCenter().postNotificationName(userHasLoginNote, object: "toNewfeature")
            }) { (_, error) -> Void in
            print(error)
        }
    }
}


//MARK: - 实现webView代理方法监听网络请求
extension OAuthViewController : UIWebViewDelegate{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL!
        
        //用户点击授权后返回http://www.baidu.com/?code=3c09cc9549cfee20be17b7fceb6d0773
        //取消授权则返回http://www.baidu.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        
        if url.absoluteString.hasPrefix(redirect_uri){
            //print(url)
            switch url.query?.hasPrefix("code="){
            //判断参数是否由"code="开头，如果是则将code记录，否则直接close()
            case true?:
                code = (url.query! as NSString).substringFromIndex(5)
                //print("got code + \(code)")
                close()
                getAccessToken()
                break
            case false?:
                print("no code")
                close()
                break
            default:
                break
            }
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}