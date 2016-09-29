//
//  SecondViewController.swift
//  Swimer
//
//  Created by  cxy on 16/8/21.
//  Copyright © 2016年 cxy. All rights reserved.
//
import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.blue
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNot(_:)), name: NSNotification.Name(rawValue: postPageDidChange), object: nil)
    }
    ///是否第一次进入此子控制器
    var firstIn = true
    
    func receiveNot(_ notfy: Notification) {
        if notfy.object as! Int == 1{
            //TODO: 加载主要内容
            firstIn = false
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

}
