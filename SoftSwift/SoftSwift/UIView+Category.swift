//
//  UIView+Category.swift
//  SoftSwift
//
//  Created by Mac mini on 16/4/7.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

extension UIView{
    ///找到该uiview对应的控制器
    func findTheController() -> UIViewController?{
        var next = superview
        while  next != nil {
            let nextResponder = next?.nextResponder()
            if nextResponder?.isKindOfClass(UIViewController.classForCoder()) == true{
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
}
