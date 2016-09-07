//
//  FirstViewController.swift
//  Swimer
//
//  Created by  cxy on 16/8/21.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveNot(_:)), name: postPageDidChange, object: nil)
        
        view.backgroundColor = UIColor.redColor()
    }
    
    func receiveNot(notfy: NSNotification) {
        if notfy.object?.intValue == 0{
            //TODO: 加载主要内容
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
