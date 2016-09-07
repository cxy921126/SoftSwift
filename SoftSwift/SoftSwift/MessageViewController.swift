//
//  MessageViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/3.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - 设置未登录页面
    override func setUnloginView() {
        super.setUnloginView()
        unloginView.titleImage.image = UIImage(named: "visitordiscover_image_message")
        unloginView.rotateImage.hidden = true
        unloginView.descriptionLabel.text = "You can receive messages after login."
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
