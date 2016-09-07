//
//  ThirdViewController.swift
//  Swimer
//
//  Created by  cxy on 16/8/21.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class ThirdViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.yellowColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveNot(_:)), name: postPageDidChange, object: nil)
        
        let vc0 = UIViewController()
        vc0.title = "VC0"
        let vc1 = UIViewController()
        vc1.title = "VC1"
        
        addChildViewController(vc0)
        addChildViewController(vc1)
        
        hideTabBar()
    }
    ///是否第一次进入此自控制器
    var firstIn = true

    func receiveNot(notfy: NSNotification) {
        if notfy.object?.intValue == 2{
            //TODO: 加载主要内容
            showTabBar()
            firstIn = false
        }else{
            hideTabBar()
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func showTabBar() {
        UIView.animateWithDuration(0.3, animations: {
            self.tabBar.frame.origin = CGPoint(x: 0, y: self.view.bounds.height - 49)
            }, completion: nil)
    }
    
    func hideTabBar() {
        tabBar.frame.origin = CGPoint(x: 0, y: screenHeight)
    }
}
