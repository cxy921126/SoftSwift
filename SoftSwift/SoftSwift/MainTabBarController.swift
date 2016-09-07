//
//  MainTabBarController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/3.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        deploy()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //布局在viewWillAppear写
        let btnWidth = UIScreen.mainScreen().bounds.width / CGFloat(childViewControllers.count)
        let btnHeight = tabBar.bounds.height
        tabBar.addSubview(centerBtn)
        centerBtn.frame = CGRect(x: btnWidth * 2, y: 0, width: btnWidth, height: btnHeight)
    }
    
    func deploy(){
        //获取JSON路径，转成NSData后，序列化为数组
        let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings", ofType: "json")
        let jsonData = NSData(contentsOfFile: jsonPath!)
        do{
            let dicArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
            for dic in dicArr as! [[String:String]]{
                //取出项目的命名空间
                let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
                //拼接成 命名空间.类名 的格式后将字符串转为Class
                let vcClass : AnyClass? = NSClassFromString(nameSpace + "." + dic["vcName"]!)
                //确定Class的类型，并用init方法实例化
                let vcController = vcClass as! UIViewController.Type
                let vc = vcController.init()
                //添加实例化的控制器到主控制器中
                addChildVC(vc, withName: dic["title"]!, andImage: dic["imageName"]!, andSelectedName: dic["imageName"]!+"_highlighted")
            }
        }
        catch{
            print(error)
        }
    }

    func addChildVC(viewController:UIViewController, withName name:String, andImage imageName:String, andSelectedName selectedImageName:String){
        viewController.title = name
        let image = UIImage(named: imageName)//?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let selectedImage = UIImage(named: selectedImageName)//?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)ios7之后可以直接用tabBar.tintColor同时渲染图片和文字颜色
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        if name == ""{
            viewController.tabBarItem.enabled = false
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        addChildViewController(navController)
    }
    
    ///Center Button
    private lazy var centerBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: #selector(postWeibo), forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.enabled = isLogin
        return btn
    }()
    
    func postWeibo(){
        let postVC = PostViewController(nibName: "PostViewController", bundle: nil)
        presentViewController(postVC, animated: true, completion: nil)
    }

}
