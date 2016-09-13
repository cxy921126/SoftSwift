//
//  FirstViewController.swift
//  Swimer
//
//  Created by  cxy on 16/8/21.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let cellIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    ///记录滚动的offset,用于判断滚动方向
    var startOffset: CGFloat?
    var endOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveNot(_:)), name: postPageDidChange, object: nil)
        
        view.backgroundColor = UIColor.redColor()
        
        tableView.registerNib(UINib(nibName: "LearnCellView", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 80
    }
    
    func receiveNot(notfy: NSNotification) {
        if notfy.object?.intValue == 0{
            //TODO: 加载主要内容
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension FirstViewController: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        //cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}

extension FirstViewController: UITableViewDelegate, UIScrollViewDelegate{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //解决tableview顶部留白问题，返回值为0时会返回默认距离
        if  section == 0 {
            return 60
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //必须实现heightForHeaderInSection方法
        if section == 0 {
            let view = NSBundle.mainBundle().loadNibNamed("headerView", owner: self, options: nil).last as! UIView
            return view
        }else{
            return nil
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.y
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endOffset = scrollView.contentOffset.y
        if endOffset > startOffset {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
}
