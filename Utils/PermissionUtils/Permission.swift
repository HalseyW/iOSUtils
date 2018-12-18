//
//  PermissionUtils.swift
//  iOSUtils
//
//  Created by Wushhhhhh on 2017/8/25.
//  Copyright © 2018年 wushhhhhh. All rights reserved.
//
//1. 非必要权限，在用的地方请求，且只请求一次。
//2. 必要权限先提示再请求，被拒绝时弹框并提供跳转到设置的选项。
//3. 多个必要权限，单独界面提供单独按钮，点击按钮后请求，被拒绝时弹框并提供跳转到设置的选项。
import Foundation
import UIKit

class Permission: NSObject {
    internal typealias Callback = (PermissionStatus) -> Void
    var callback: Callback?

    lazy var deniedAlert: DeniedAlert = {return DeniedAlert(permissionUtils: self)}()
    lazy var cancelAlert: CancelAlert = {return CancelAlert(permissionUtils: self)}()
    lazy var preAlert: PreAlert = {return PreAlert(permissionUtils: self)}()
    var shouldPresentDeniedAlert = true
    var shouldPresentCancelAlert = true
    var shouldPresentPreAlert = true
    
    let permissionType: PermissionType
    var permissionStatus: PermissionStatus {
        switch permissionType {
        case .Camera:
            return cameraPermissionStatus
        case .Mic:
            return micPermissionStatus
        case .Photo:
            return photoPermissionStatus
        }
    }

    init(type: PermissionType) {
        self.permissionType = type
    }

    func request(_ callback: @escaping Callback) {
        self.callback = callback
        let status = permissionStatus
        switch status {
        case .authorized:
            callbacks(status)
        case .denied:
            shouldPresentDeniedAlert ? deniedAlert.present() : callbacks(status)
        case .notDetermined:
            shouldPresentCancelAlert ? preAlert.present() : requestPermission(callbacks(_:))
        case .restricted:
            shouldPresentPreAlert ? cancelAlert.present() : callbacks(status)
        }
    }
    
    internal func requestPermission(_ callback: @escaping Callback) {
        switch permissionType {
        case .Camera:
            requestCamera(callback)
        case .Mic:
            requestMic(callback)
        case .Photo:
            requestPhotos(callback)
        }
    }
    
    internal func callbacks(_ with: PermissionStatus) {
        DispatchQueue.main.async {
            self.callback?(self.permissionStatus)
        }
    }
}