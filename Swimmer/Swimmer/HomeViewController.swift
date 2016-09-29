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

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let postPageDidChange = "pageDidChange"

class HomeViewController: UIViewController, CityViewControllerDelegate, LocationToolDelegate {
    
    @IBOutlet weak var tabView: UIScrollView!
    @IBOutlet weak var childControllersScrollView: UIScrollView!
    
    lazy var locationTool = LocationTool(withMode: .fixed)
    
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        
        if let storedCity = UserDefaults.standard.object(forKey: "city"){
            //如果已经保存了城市则设为按钮标题
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: (storedCity as! String), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showCityVC))
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "地点", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showCityVC))

        }
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray], for: UIControlState())
        
        //下一层VC的返回按钮
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    //MARK: - 地点设置
    var currentCity: String?{
        didSet{
            if self.currentCity != nil{
                self.navigationItem.leftBarButtonItem?.title = self.currentCity
                let userDefault = UserDefaults.standard
                userDefault.set(self.currentCity, forKey: "city")
            }else{
                self.navigationItem.leftBarButtonItem?.title = "地点"
            }
        }
    }
    
    lazy var cityVC: CityViewController = {
        let cityVC = self.storyboard?.instantiateViewController(withIdentifier: "city") as! CityViewController
        cityVC.delegate = self
        return cityVC
    }()
    
    func showCityVC() {
        navigationController?.pushViewController(cityVC, animated: true)
    }
    //CityViewControllerDelegate实现
    func cityViewController(_ cityVC: CityViewController, didSelectCity city: String) {
        print(city)
        currentCity = city
    }
    //LocationToolDelegate实现
    func locationTool(_ locationTool: LocationTool, detectedNewLocation city: String) {
        let confirmAlert = UIAlertController(title: "检测到新地点", message: "是否切换到:\(city)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "是的", style: .default) { (_) in
            self.currentCity = city
        }
        
        confirmAlert.addAction(confirmAction)
        confirmAlert.addAction(cancelAction)
        present(confirmAlert, animated: true, completion: nil)
    }
    
    //MARK: - 设置scrollview和子控制器
    ///设置子控制器scrollview
    func setChildScrollView(){
        childControllersScrollView.contentSize = CGSize(width: screenWidth * 3, height: screenHeight - 64 - tabView.bounds.height)
        childControllersScrollView.isPagingEnabled = true
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
    
    func addSubController(_ storyboardIdentifier: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: storyboardIdentifier)
        
        addChildViewController(vc!)
        childControllersScrollView.addSubview(vc!.view)
        vc!.view.snp.makeConstraints { (make) in
            if self.childViewControllers.first == vc {
                make.leading.equalTo(childControllersScrollView.snp.leading)
            }else{
                let index = childControllersScrollView.subviews.index(of: vc!.view)
                make.leading.equalTo(childControllersScrollView.subviews[index! - 1].snp.trailing)
            }
            make.top.equalTo(childControllersScrollView.snp.top)
            make.width.equalTo(screenWidth)
            make.height.equalTo(childControllersScrollView.snp.height)
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
    
    func addButton(_ title: String){
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.lightGray, for: UIControlState())
        button.addTarget(self, action: #selector(moveToButtonCenterCons(_:)), for: UIControlEvents.touchUpInside)
        tabView.addSubview(button)
        buttonArr.append(button)
        buttonCount += 1
        
        let pureDistance = buttonDistance-buttonWidth
        let firstOffset = (screenWidth-3*buttonWidth-2*pureDistance)/2
        button.snp.makeConstraints { (make) in
            _ = buttonCount >= 2 ? make.leading.equalTo(buttonArr[buttonCount-2].snp.trailing).offset(10) : make.leading.equalTo(tabView.snp.leading).offset(firstOffset)
            make.centerY.equalTo(tabView.snp.centerY)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(30)
        }
    }
    
    ///设置按钮底scrollIndicator
    func addScrollIndicator(){
        let scrollBlock = UIView(frame: CGRect.zero)
        
        scrollBlock.backgroundColor = UIColor.blue
        self.scrollIndicator = scrollBlock
        tabView.addSubview(self.scrollIndicator!)
        self.scrollIndicator!.snp.makeConstraints({ (make) in
            self.centerXConstraint = make.centerX.equalTo(buttonArr[0].snp.centerX).constraint
            make.bottom.equalTo(tabView.snp.bottom).offset(tabView.bounds.height)
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
    
    func moveToButtonCenterCons(_ button: UIButton){
        let index = buttonArr.index(of: button)
        UIView.animate(withDuration: 0.2, animations: {
            self.childControllersScrollView.contentOffset = CGPoint(x: screenWidth * CGFloat(index!), y: 0)
            self.updateCons(button)
        })
        self.calculatePageNo(self.childControllersScrollView.contentOffset.x)
    }
    //MARK: - 更新滚动条和子控制器scrollview的滚动
    ///更新约束
    func updateCons(_ button: UIButton){
//        self.scrollBlock?.snp_updateConstraints(closure: { (make) in
//            self.centerXConstraint?.uninstall()
//            self.centerXConstraint = make.centerX.equalTo(button.snp_centerX).constraint
//        })
        let index = buttonArr.index(of: button)
        childControllersScrollView.contentOffset.x = CGFloat(index!) * screenWidth
    }
    
    ///滚动条动画
    func scollIndicatorAnimation(){
        UIView.animate(withDuration: 0.1, animations: {
            self.centerXConstraint?.update(offset: self.buttonDistance * (self.childControllersScrollView.contentOffset.x / screenWidth))
            self.view.layoutIfNeeded()
        })
    }
    
    ///总页数
    let pageCount = 3
    ///页码
    var pageNo = 0{
        didSet{
            NotificationCenter.default.post(name: Notification.Name(rawValue: postPageDidChange), object: pageNo)
        }
    }
    
    func calculatePageNo(_ contentOffset: CGFloat){
        pageNo = Int(contentOffset / screenWidth)
    }
}
//MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate{
    //滚动条随着scrollview按比例移动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == childControllersScrollView && childControllersScrollView.contentOffset.x <= screenWidth * CGFloat(pageCount - 1) {
            self.scollIndicatorAnimation()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == childControllersScrollView {
            calculatePageNo(scrollView.contentOffset.x)
        }
    }
}


