//
//  ViewController.swift
//  Swimer
//
//  Created by  cxy on 16/8/20.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height
let postPageDidChange = "pageDidChange"

class HomeViewController: UIViewController, CityViewControllerDelegate, LocationToolDelegate {
    
    @IBOutlet weak var tabView: UIScrollView!
    @IBOutlet weak var childControllersScrollView: UIScrollView!
    
    lazy var locationTool = LocationTool(withMode: .Fixed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpNaviBar()
        setUpTabView()
        
        addScrollIndicator()
        setChildScrollView()
        setChildViewControllers()
        
        locationTool.delegate = self
    }
    
    //MARK: - 导航栏设置
    ///设置导航栏
    func setUpNaviBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if let storedCity = NSUserDefaults.standardUserDefaults().objectForKey("city"){
            //如果已经保存了城市则设为按钮标题
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: (storedCity as! String), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(showCityVC))
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "地点", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(showCityVC))

        }
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGrayColor()], forState: UIControlState.Normal)
        
        //下一层VC的返回按钮
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
    }
    
    //MARK: - 地点设置
    var currentCity: String?{
        didSet{
            if self.currentCity != nil{
                self.navigationItem.leftBarButtonItem?.title = self.currentCity
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(self.currentCity, forKey: "city")
            }else{
                self.navigationItem.leftBarButtonItem?.title = "地点"
            }
        }
    }
    
    lazy var cityVC: CityViewController = {
        let cityVC = self.storyboard?.instantiateViewControllerWithIdentifier("city") as! CityViewController
        cityVC.delegate = self
        return cityVC
    }()
    
    func showCityVC() {
        navigationController?.pushViewController(cityVC, animated: true)
    }
    //CityViewControllerDelegate实现
    func cityViewController(cityVC: CityViewController, didSelectCity city: String) {
        print(city)
        currentCity = city
    }
    //LocationToolDelegate实现
    func locationTool(locationTool: LocationTool, detectedNewLocation city: String) {
        let confirmAlert = UIAlertController(title: "检测到新地点", message: "是否切换到:\(city)", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "是的", style: .Default) { (_) in
            self.currentCity = city
        }
        
        confirmAlert.addAction(confirmAction)
        confirmAlert.addAction(cancelAction)
        presentViewController(confirmAlert, animated: true, completion: nil)
    }
    
    //MARK: - 设置scrollview和子控制器
    ///设置子控制器scrollview
    func setChildScrollView(){
        childControllersScrollView.contentSize = CGSize(width: screenWidth * 3, height: screenHeight - 64 - tabView.bounds.height)
        childControllersScrollView.pagingEnabled = true
        childControllersScrollView.showsHorizontalScrollIndicator = false
        childControllersScrollView.bounces = false
        childControllersScrollView.delegate = self
        childControllersScrollView.scrollsToTop = false
    }
    
    ///设置子控制器
    func setChildViewControllers(){
        addSubController("first")
        addSubController("second")
        addSubController("third")
    }
    
    func addSubController(storyboardIdentifier: String){
        let vc = storyboard?.instantiateViewControllerWithIdentifier(storyboardIdentifier)
        
        addChildViewController(vc!)
        childControllersScrollView.addSubview(vc!.view)
        vc!.view.snp_makeConstraints { (make) in
            if self.childViewControllers.first == vc {
                make.leading.equalTo(childControllersScrollView.snp_leading)
            }else{
                let index = childControllersScrollView.subviews.indexOf(vc!.view)
                make.leading.equalTo(childControllersScrollView.subviews[index! - 1].snp_trailing)
            }
            make.top.equalTo(childControllersScrollView.snp_top)
            make.width.equalTo(screenWidth)
            make.height.equalTo(childControllersScrollView.snp_height)
        }
    }
    
    //MARK: - tabview、button设置
    ///设置标签scrollview
    func setUpTabView(){
        tabView.contentSize = CGSize(width: screenWidth, height: tabView.frame.height)
        tabView.showsVerticalScrollIndicator = false
        tabView.showsHorizontalScrollIndicator = false
        tabView.bounces = false
        tabView.scrollsToTop = false
        automaticallyAdjustsScrollViewInsets = false
        
        addButton("求学")
        addButton("游伴")
        addButton("我的")
    }
    
    var buttonCount = 0
    var buttonArr = [UIButton]()
    ///按钮宽度
    var buttonWidth: CGFloat = 80
    
    
    func addButton(title: String){
        let button = UIButton()
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(moveToButtonCenterCons(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        tabView.addSubview(button)
        buttonArr.append(button)
        buttonCount += 1
        
        let firstOffset = (screenWidth-3*buttonWidth-2*(buttonDistance-buttonWidth))/2
        button.snp_makeConstraints { (make) in
            buttonCount >= 2 ? make.leading.equalTo(buttonArr[buttonCount-2].snp_trailing).offset(10) : make.leading.equalTo(tabView.snp_leading).offset(firstOffset)
            make.centerY.equalTo(tabView.snp_centerY)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(30)
        }
    }
    
    ///设置按钮底scrollIndicator
    func addScrollIndicator(){
        let scrollBlock = UIView(frame: CGRectZero)
        
        scrollBlock.backgroundColor = UIColor.blueColor()
        self.scrollIndicator = scrollBlock
        tabView.addSubview(self.scrollIndicator!)
        self.scrollIndicator!.snp_makeConstraints(closure: { (make) in
            self.centerXConstraint = make.centerX.equalTo(buttonArr[0].snp_centerX).constraint
            make.bottom.equalTo(tabView.snp_bottom).offset(tabView.bounds.height)
            make.width.equalTo(buttonWidth - 30)
            make.height.equalTo(3)
        })
    }
    
    //MARK: - 点击按钮
    ///按钮下滚动条
    var scrollIndicator: UIView?
    ///被更新的中间约束
    var centerXConstraint: Constraint?
    ///按钮正中之间的距离
    var buttonDistance: CGFloat = 90
    
    func moveToButtonCenterCons(button: UIButton){
        let index = buttonArr.indexOf(button)
        UIView.animateWithDuration(0.2, animations: {
            self.childControllersScrollView.contentOffset = CGPoint(x: screenWidth * CGFloat(index!), y: 0)
            self.updateCons(button)
        })
        self.calculatePageNo(self.childControllersScrollView.contentOffset.x)
    }
    //MARK: - 更新滚动条和子控制器scrollview的滚动
    ///更新约束
    func updateCons(button: UIButton){
//        self.scrollBlock?.snp_updateConstraints(closure: { (make) in
//            self.centerXConstraint?.uninstall()
//            self.centerXConstraint = make.centerX.equalTo(button.snp_centerX).constraint
//        })
        let index = buttonArr.indexOf(button)
        childControllersScrollView.contentOffset.x = CGFloat(index!) * screenWidth
    }
    
    ///滚动条动画
    func scollIndicatorAnimation(){
        UIView.animateWithDuration(0.1, animations: {
            self.centerXConstraint?.updateOffset(self.buttonDistance * (self.childControllersScrollView.contentOffset.x / screenWidth))
            self.view.layoutIfNeeded()
        })
    }
    
    ///总页数
    let pageCount = 3
    ///页码
    var pageNo = 0{
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName(postPageDidChange, object: pageNo)
        }
    }
    
    func calculatePageNo(contentOffset: CGFloat){
        pageNo = Int(contentOffset / screenWidth)
    }
}
//MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate{
    //滚动条随着scrollview按比例移动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == childControllersScrollView && childControllersScrollView.contentOffset.x <= screenWidth * CGFloat(pageCount - 1) {
            self.scollIndicatorAnimation()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == childControllersScrollView {
            calculatePageNo(scrollView.contentOffset.x)
        }
    }
}


