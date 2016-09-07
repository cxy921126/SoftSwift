//
//  BaseViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/5.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController, UnloginViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unloginView.delegate = self
        if isLogin{
            tableView.separatorStyle = .None
        }
    }
    
    //MARK: - 根据登录状态初始化view

    override func loadView() {
        isLogin ? super.loadView():setUnloginView()
    }
    
    //MARK: - 未登录View设为属性
    lazy var unloginView:UnloginView = {
        let thisView = NSBundle.mainBundle().loadNibNamed("UnloginView", owner: self, options: nil).last as! UnloginView
        return thisView
    }()
    
    func setUnloginView(){
        view = unloginView
    }
    
    //MARK: - 实现UnloginViewDelegate代理方法
    func presentSignUp() {
    }
    
    func presentLogin() {
        let oauthCtr = OAuthViewController()
        let navCtr = UINavigationController(rootViewController: oauthCtr)
        presentViewController(navCtr, animated: true, completion: nil)
    }
}
