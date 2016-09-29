//
//  CityViewController.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/8.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit
@objc protocol CityViewControllerDelegate: NSObjectProtocol {
    @objc optional func cityViewController(_ cityVC: CityViewController, didSelectCity city: String)
}

class CityViewController: UITableViewController, LocationToolDelegate {
    weak var delegate: CityViewControllerDelegate?
    var cities = ["北京市", "上海市", "广州市", "深圳市", "厦门市", "杭州市", "福州市"]
    let cityCellIdentifier = "cityCell"
    var locationTool = LocationTool(withMode: .detectOnly)
    var currentCity: String?{
        didSet{
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTool.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cityCellIdentifier)
        title = "选择城市"
    }
    
    //MARK: - LocationToolDelegate
    func locationTool(_ locationTool: LocationTool, onlyGetCity city: String) {
        currentCity = city
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return cities.count
        }else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath)
        // Configure the cell...
        if (indexPath as NSIndexPath).section == 0 {
            if currentCity == nil {
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                cell.accessoryView = indicator
                cell.accessoryView?.isHidden = false
                indicator.startAnimating()
            }else{
                cell.accessoryView?.isHidden = true
                cell.textLabel?.text = currentCity
            }

        }else{
            cell.textLabel?.text = cities[(indexPath as NSIndexPath).row]
            cell.detailTextLabel?.text = "hehe"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "热门城市"
        }else{
            return "当前定位城市"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 1 {
            delegate?.cityViewController!(self, didSelectCity: cities[(indexPath as NSIndexPath).row])
            _ = navigationController?.popViewController(animated: true)
        }else{
            if tableView.cellForRow(at: indexPath)?.textLabel?.text != nil {
                delegate?.cityViewController!(self, didSelectCity: currentCity!)
                 _ = navigationController?.popViewController(animated: true)
            }
        }
    }

}
