//
//  DetailLearnController.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/20.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit
import SnapKit

let detailCellIdentifier = "detailCell"
class DetailLearnController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var learning: Learning?
    var detailArr: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.barStyle = .black
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: detailCellIdentifier)
        tableView.tableFooterView = UIView()
        
        setTableHeaderView()
        
        dicToArr()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.subviews.first?.alpha = 0
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.subviews.first?.alpha = 1
    }
    
    var tableHeaderView: userAvatarHeader?
    ///存储背景图片初始高度用于计算放大倍数
    var backgroundHeight: CGFloat?
    
    func setTableHeaderView(){
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 175))
        backgroundView.backgroundColor = UIColor.clear
        
        let headerView = Bundle.main.loadNibNamed("userAvatarHeader", owner: self, options: nil)?.last as! userAvatarHeader
        headerView.avatarView.image = UIImage(named: (learning?.user!.avatarAddress)!)
        headerView.genderView.image = UIImage(named: (learning?.user!.gender)!)
        headerView.personalityLabel.text = "个性签名:\(learning!.user!.personalDescription!)"
        tableHeaderView = headerView
        
        backgroundView.addSubview(tableHeaderView!)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo((headerView.superview?.snp.top)!)
            make.leading.equalTo((headerView.superview?.snp.leading)!)
            make.trailing.equalTo((headerView.superview?.snp.trailing)!)
            make.bottom.equalTo((headerView.superview?.snp.bottom)!)
        }
        tableView.tableHeaderView = backgroundView
        backgroundHeight = tableHeaderView?.backGroundView.bounds.height
    }
    
    func dicToArr() {
        detailArr.append(learning!.user!.nickName!)
        detailArr.append(learning!.natatorium!)
        detailArr.append(learning!.expectedTime!)
        detailArr.append(learning!.learningDescription!)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension DetailLearnController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier)
        cell?.textLabel?.text = detailArr[(indexPath as NSIndexPath).row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailLearnController: UIScrollViewDelegate{
    //MARK: 头像背景缩放
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset < 0 {
//            let scaleFactor = (abs(yOffset) + (tableHeaderView?.bounds.height)!) / (tableHeaderView?.bounds.height)!
//            tableHeaderView?.backGroundView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
            let totalOffset = backgroundHeight! + abs(yOffset)
            let scaleFactor = totalOffset / backgroundHeight!
            tableHeaderView?.backGroundView.frame = CGRect(x: (screenWidth - screenWidth * scaleFactor)/2, y: yOffset, width: screenWidth * scaleFactor, height: totalOffset)
        }
    }
}
