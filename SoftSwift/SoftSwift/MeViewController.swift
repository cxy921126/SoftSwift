//
//  MeViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/3.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

let cellOfMeViewController = "cellOfMeViewController"

class MeViewController: BaseViewController {
    let meVCData = [["我的好友"],["我的相册","我的赞","我的收藏"],["更多"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            return
        }
        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Grouped)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellOfMeViewController)
    }
    
    //MARK: - 设置未登录页面
    override func setUnloginView() {
        super.setUnloginView()
        unloginView.titleImage.image = UIImage(named: "visitordiscover_image_profile")
        unloginView.rotateImage.hidden = true
        unloginView.descriptionLabel.text = "Your profile will be displaying after login."
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return meVCData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meVCData[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellOfMeViewController, forIndexPath: indexPath)
        cell.textLabel?.text = meVCData[indexPath.section][indexPath.row]
        return cell
    }
}
