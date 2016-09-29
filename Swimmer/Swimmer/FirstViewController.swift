//
//  FirstViewController.swift
//  Swimer
//
//  Created by  cxy on 16/8/21.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit
import Alamofire
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FirstViewController: UIViewController {
    let cellIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    ///记录滚动的offset,用于判断滚动方向
    var startOffset: CGFloat?
    var endOffset: CGFloat?
    var learningArr: [Learning] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNot(_:)), name: NSNotification.Name(rawValue: postPageDidChange), object: nil)
        
        view.backgroundColor = UIColor.red
        
        tableView.register(UINib(nibName: "LearnCellView", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 83
        
        Alamofire.request("http://localhost:3000/Learning").responseJSON { (response) in
            if response.result.error == nil{
                let dataArr = response.result.value as! [AnyObject]
                for data in dataArr{
                    let learnItem = Learning(dict: data as! [String : AnyObject])
                    self.learningArr.append(learnItem)
                }
            }
        }
    }
    
    func receiveNot(_ notfy: Notification) {
        if notfy.object as! Int == 0{
            //TODO: 加载主要内容
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

extension FirstViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learningArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! LearnCell
        let learingObj = learningArr[(indexPath as NSIndexPath).row]
        cell.avatar.image = UIImage(named: learingObj.user!.avatarAddress!)
        cell.nickNameLabel.text = learingObj.user!.nickName
        cell.genderImage.image = UIImage(named: learingObj.user!.gender!)
        cell.natatoriumLabel.text = learingObj.natatorium
        cell.expectedTimeLabel.text = learingObj.expectedTime
        return cell
    }
}

extension FirstViewController: UITableViewDelegate, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailLearnController
        detailVC.learning = learningArr[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //解决tableview顶部留白问题，返回值为0时会返回默认距离
        if  section == 0 {
            return 60
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //必须实现heightForHeaderInSection方法
        if section == 0 {
            let view = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.last as! UIView
            return view
        }else{
            return nil
        }
    }
    
    //MARK: - 隐藏导航栏
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.y
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endOffset = scrollView.contentOffset.y
        if endOffset > startOffset {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
