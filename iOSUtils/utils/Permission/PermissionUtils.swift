//
//  PermissionUtils.swift
//  iOSUtils
//
//  Created by Wushhhhhh on 2017/8/25.
//  Copyright © 2018年 wushhhhhh. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PermissionUtils: NSObject {
    static let cameraUsageDescription = "NSCameraUsageDescription"
    static let micUsageDescription = "NSMicrophoneUsageDescription"
    static let photoUsageDescription = "NSPhotoLibraryUsageDescription"

    typealias Callback = (PermissionStatus) -> Void
    var callback: Callback?

    lazy var deniedAlert: DeniedAlert = {return DeniedAlert(permissionUtils: self)}()
    lazy var cancelAlert: CancelAlert = {return CancelAlert(permissionUtils: self)}()
    lazy var preAlert: PreAlert = {return PreAlert(permissionUtils: self)}()
    var shouldPresentDeniedAlert = true
    var shouldPresentCancelAlert = true
    var shouldCancelPreAlert = true
    
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
            shouldCancelPreAlert ? cancelAlert.present() : callbacks(status)
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

enum PermissionType: String {
    case Camera = "Camera"
    case Mic = "Mic"
    case Photo = "Photo"
}

enum PermissionStatus: String {
    case authorized = "authorized"
    case denied = "denied"
    case notDetermined = "notDetermined"
    case restricted = "restricted"
}

extension UIApplication {
    var topViewController: UIViewController? {
        var vc = delegate?.window??.rootViewController
        while let presentedVC = vc?.presentedViewController {
            vc = presentedVC
        }
        return vc
    }

    func presentViewController(_ viewController: UIViewController) {
        topViewController?.present(viewController, animated: true, completion: nil)
    }
}
