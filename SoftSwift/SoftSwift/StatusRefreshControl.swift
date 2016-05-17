//
//  StatusRefreshControl.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/28.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class StatusRefreshControl: UIRefreshControl {
    
    @IBOutlet weak var rotateImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var arrowView: UIView!
    
    override func awakeFromNib() {
        //添加对frame的监视器
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit{
        removeObserver(self, forKeyPath: "frame")
    }

    ///圆圈旋转标识
    var isRotate = false
    
    //MARK: - 重写kvo方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            let pullY = object?.frame.origin.y
            
            if (pullY == -64 || pullY == 0.0) {
                arrowView.hidden = false
                return
            }
            
            if pullY == -60{
                //isUP = false
                arrowView.hidden = true
                if !isRotate{
                    isRotate = true
                    rotateAnimate()
                    //swift的延时,时长为Int64(3*Double(NSEC_PER_SEC))
                    //let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1*Double(NSEC_PER_SEC)))
                    //dispatch_after(delay, dispatch_get_main_queue(), {
                    //})
                }
            }
        }
    }
    
    //MARK: - 动画
    func rotateAnimate(){
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.toValue = 2 * M_PI
        animate.duration = 1
        animate.repeatCount = MAXFLOAT
        animate.cumulative = true
        rotateImage.layer.addAnimation(animate, forKey: nil)
    }
}
