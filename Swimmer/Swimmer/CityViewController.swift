//
//  CityViewController.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/8.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit
@objc protocol CityViewControllerDelegate: NSObjectProtocol {
    optional func cityViewController(cityVC: CityViewController, didSelectCity city: String)
}

class CityViewController: UITableViewController, LocationToolDelegate {
    weak var delegate: CityViewControllerDelegate?
    var cities = ["北京市", "上海市", "广州市", "深圳市", "厦门市", "杭州市", "福州市"]
    let cityCellIdentifier = "cityCell"
    var locationTool = LocationTool(withMode: .DetectOnly)
    var currentCity: String?{
        didSet{
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTool.delegate = self
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cityCellIdentifier)
        title = "选择城市"
    }
    
    //MARK: - LocationToolDelegate
    func locationTool(locationTool: LocationTool, onlyGetCity city: String) {
        currentCity = city
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return cities.count
        }else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cityCellIdentifier, forIndexPath: indexPath)
        // Configure the cell...
        if indexPath.section == 0 {
            if currentCity == nil {
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.accessoryView = indicator
                cell.accessoryView?.hidden = false
                indicator.startAnimating()
            }else{
                cell.accessoryView?.hidden = true
                cell.textLabel?.text = currentCity
            }

        }else{
            cell.textLabel?.text = cities[indexPath.row]
            cell.detailTextLabel?.text = "hehe"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "热门城市"
        }else{
            return "当前定位城市"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 {
            delegate?.cityViewController!(self, didSelectCity: cities[indexPath.row])
            navigationController?.popViewControllerAnimated(true)
        }else{
            if tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text != nil {
                delegate?.cityViewController!(self, didSelectCity: currentCity!)
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}
