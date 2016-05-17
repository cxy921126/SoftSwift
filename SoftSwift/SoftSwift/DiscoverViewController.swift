//
//  DiscoverViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/3.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    //MARK: - 设置未登录页面
    override func setUnloginView() {
        super.setUnloginView()
        unloginView.titleImage.image = UIImage(named: "visitordiscover_image_message")
        unloginView.rotateImage.hidden = true
        unloginView.descriptionLabel.text = "Login and look what everyone talk about."
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
