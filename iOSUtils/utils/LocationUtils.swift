//  LocationUtils.swift
//  iOSUtils
//
//  Created by Wushhhhhh on 2018/8/25.
//  Copyright © 2018年 wushhhhhh. All rights reserved.
//  开发者文档：https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/LocationAwarenessPG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009497-CH1-SW1
//  info.plist 添加权限
//  1. Privacy - Location When In Use Usage Description
//  2. Privacy - Location Always and When In Use Usage Description
//  3. 需要联网
import Foundation
import CoreLocation

class LocationUtils: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    /**
     请求城市名称
     */
    func startRequestCityName() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            delegate?.requestCityNameResult(isSuccess: false, cityName: "", error: .DENIAL)
        } else if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
    }
    
    /**
     获取到位置之后的回调
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count != 0 {
            getCityName(location: locations.last!)
        } else {
            delegate?.requestCityNameResult(isSuccess: false, cityName: "", error: .OTHER)
        }
    }
    
    /**
     获取到位置错误之后的回调
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.requestCityNameResult(isSuccess: false, cityName: "", error: .OTHER)
    }
    
    /**
     反编译地理坐标成具体城市名
     */
    func getCityName(location: CLLocation) {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if placeMarks?.count != 0 {
                let cityName = placeMarks?.first?.locality
                self.delegate?.requestCityNameResult(isSuccess: true, cityName: cityName!, error: .NO_ERROR)
            } else {
                self.delegate?.requestCityNameResult(isSuccess: false, cityName: "", error: .OTHER)
            }
        }
    }
}

/**
 回调delegate
 */
protocol LocationServiceDelegate {
    func requestCityNameResult(isSuccess: Bool, cityName: String, error: LocationServiceError)
}

/**
 错误枚举
 */
enum LocationServiceError {
    case DENIAL
    case NO_NETWORK
    case OTHER
    case NO_ERROR
}
