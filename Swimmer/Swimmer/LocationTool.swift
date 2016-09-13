//
//  LocationTool.swift
//  Swimmer
//
//  Created by Mac mini on 16/9/9.
//  Copyright © 2016年 cxy. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocationToolDelegate: NSObjectProtocol{
    optional func locationTool(locationTool: LocationTool, detectedNewLocation city: String)
    optional func locationTool(locationTool: LocationTool, onlyGetCity city: String)
}

enum LocationToolMode {
    case Fixed
    case DetectOnly
}

class LocationTool: NSObject {
    ///保存实例的模式
    var toolMode: LocationToolMode?
    
    weak var delegate: LocationToolDelegate?
    
    var geoCoder = CLGeocoder()
    
    lazy var locationMgr: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        if Float(UIDevice.currentDevice().systemVersion) >= 8.0 {
            manager.requestWhenInUseAuthorization()
            manager.distanceFilter = 1000
            manager.startUpdatingLocation()
        }else{
            print("Location Service disabled")
        }
        return manager
    }()
    
    init(withMode: LocationToolMode) {
        super.init()
        toolMode = withMode
        fixedLocation(.Fixed)
    }
    
    func fixedLocation(withMode: LocationToolMode){
        guard let location = locationMgr.location else {
            print("can not get location")
            return 
        }
        switch withMode {
        case .Fixed:
            geoCoder.reverseGeocodeLocation(location) { (places, error) in
                if error != nil{
                    print(error)
                }else{
                    let detectedCity = places?.first?.locality
                    if let storedCity = NSUserDefaults.standardUserDefaults().objectForKey("city") {
                        //若存在已保存的城市，判断是否不同于检测到的城市
                        if (storedCity as? String) != detectedCity && detectedCity != nil{
                            
                            self.delegate?.locationTool!(self, detectedNewLocation: detectedCity!)
                        }
                    }else{
                        self.delegate?.locationTool!(self, detectedNewLocation: detectedCity!)
                    }
                    //self.currentCity = places?.first?.locality
                }
            }
            break
            
        //只定位城市不进行比较
        case .DetectOnly:
            detectOnly(location, finished: { (city) in
                self.delegate?.locationTool!(self, onlyGetCity: city)
            })
            break
        }
    }
    
    func detectOnly(location: CLLocation, finished:(city: String)->()){
        var city: String?
        let simpleGeoCoder = CLGeocoder()
        simpleGeoCoder.reverseGeocodeLocation(location) { (places, error) in
            if error != nil{
                print(error)
            }else{
                if places?.first?.locality != nil{
                    city = (places?.first?.locality)!
                    finished(city: city!)
                }
            }
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationTool: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        fixedLocation(toolMode!)
    }
}