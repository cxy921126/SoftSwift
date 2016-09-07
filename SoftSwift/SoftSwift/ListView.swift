//
//  ListView.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/7.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

protocol ListViewDelegate:NSObjectProtocol{
    func listViewDidRemove(list:ListView)
}

class ListView: UIView {
    weak var listDelegate:ListViewDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        removeFromSuperview()
        listDelegate?.listViewDidRemove(self)
    }
}
