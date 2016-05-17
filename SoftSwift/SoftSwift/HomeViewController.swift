//
//  HomeViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/3.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class HomeViewController: BaseViewController, ListViewDelegate{
    let screenWidth  = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    let userAccount = UserAccount.readAccount()
    let cellReuseIdentifier = "cell"
    
    var statuses = [Status](){
        didSet{
            tableView.reloadData()
        }
    }
    
    ///是否加载新微博的标识(反之加载旧微博)
    var isLoadingNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin
        {
            return
        }
        //为tableview注册cell
        tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        //高度自适应
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setNaviBar()
        list.listDelegate = self
        //首次加载数据
        loadData()
        
        //下拉刷新
        refreshControl = statusRefreshControl
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        
        //刷新数量提醒
        navigationController?.view.insertSubview(hintLabel, atIndex: 1)
        hintLabel.hidden = true
        
    }
    
    
    //MARK: - 加载微博数据
    var since_id = 0
    var max_id = 0
    
    ///微博加载数量
    var newStatusesCount : Int = 0{
        didSet{
            //显示微博加载数量的动画
            hintLabel.hidden = false
            UIView.animateWithDuration(1.5, animations: {
                self.hintLabel.transform = CGAffineTransformMakeTranslation(0, 64)
                self.hintLabel.text = "\(self.newStatusesCount) Weibo Loaded."
                }) { (_) in
                    UIView.animateWithDuration(1.5, animations: { 
                        self.hintLabel.transform = CGAffineTransformIdentity
                        }, completion: { (_) in
                            self.hintLabel.hidden = true
                    })
            }
        }
    }
    
    ///微博加载数量标签
    lazy var hintLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 44))
        label.backgroundColor = UIColor.orangeColor()
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.alpha = 0.9
        return label
    }()
    
    func loadData(){
        //如果isLoadingNew为真则加载新微博，否则加载旧微博
        if isLoadingNew==true{
            if since_id == 0 {
                MBProgressHUD.showHUDAddedTo(view, animated: true)
            }
            //加载statuses
            Status.loadStatuses(since_id, max_id: 0) { (models) -> () in
                self.statuses = models + self.statuses
                self.since_id = (self.statuses.first?.id)!
                self.max_id = (self.statuses.last?.id)!
                self.refreshControl?.endRefreshing()
                
                self.newStatusesCount = models.count
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }

        else{
            Status.loadStatuses(0, max_id: max_id, finished: { (models) in
                self.statuses = self.statuses + models
                self.since_id = (self.statuses.first?.id)!
                self.max_id = (self.statuses.last?.id)!
            })
        }
        
        
    }
    
    //MARK: - 下拉刷新控件
    lazy var statusRefreshControl: StatusRefreshControl = {
        let refreshControl = NSBundle.mainBundle().loadNibNamed("StatusRefreshControl", owner: self, options: nil).first as! StatusRefreshControl
        if refreshControl.refreshing == true{
            self.isLoadingNew = true
        }
        return refreshControl
    }()
    
    //MARK: - 设置昵称按钮和导航条
    lazy var nameBtn:nameButton = {
        let nameBtn = nameButton()
        nameBtn.setTitle("UserName", forState: UIControlState.Normal)
        nameBtn.addTarget(self, action: #selector(HomeViewController.nameBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return nameBtn
    }()
    
    func setNaviBar(){
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
        leftBtn.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: UIControlState.Highlighted)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage(named: "navigationbar_pop"), forState: UIControlState.Normal)
        rightBtn.setImage(UIImage(named: "navigationbar_pop_highlighted"), forState: UIControlState.Highlighted)
        rightBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)

        nameBtn.sizeToFit()
        navigationItem.titleView = nameBtn
    }
    
    //MARK: - 设置listView
    lazy var list:ListView = {
        let list = NSBundle.mainBundle().loadNibNamed("ListView", owner: self, options: nil).last as! ListView
        list.frame = CGRect(x:0, y: 0, width: self.screenWidth, height: self.screenHeight)
        list.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        return list
    }()
    
    //MARK: - 弹出菜单
    func nameBtnClick(){
        if nameBtn.selected == false{
            //view.addSubview(list)
            navigationController?.view.addSubview(list)
            nameBtn.selected = true
        }
        else{
            list.removeFromSuperview()
            nameBtn.selected = false
        }
    }
    
    //MARK: - 实现listView移除的代理方法
    func listViewDidRemove(list: ListView) {
        nameBtn.selected = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        list.removeFromSuperview()
    }
    
    //MARK: - 设置未登录页面
    override func setUnloginView() {
        super.setUnloginView()
        unloginView.titleImage.image = UIImage(named: "visitordiscover_feed_image_house")
        unloginView.descriptionLabel.text = "Follow people to find something interesting."
        unloginView.titleImageTopMargin.constant = 175
        unloginView.titleImageBottomMargin.constant = 50
        
        let animate = CABasicAnimation(keyPath: "transform.rotation")
        animate.toValue = 2 * M_PI
        animate.speed = 2
        animate.duration = 20
        animate.repeatCount = MAXFLOAT
        animate.removedOnCompletion = false
        
        unloginView.rotateImage.layer.addAnimation(animate, forKey: nil)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! HomeTableViewCell
        
        let status = statuses[indexPath.row]
        cell.status = status
        
        
        //判断滚动到最后一条时，加载之前的微博
        if indexPath.row == statuses.count-1{
            isLoadingNew = false
            loadData()
        }
        //第一条时将isloadingnew标记改为true
        if indexPath.row == 0 {
            isLoadingNew = true
        }
        
        return cell
    }

}
