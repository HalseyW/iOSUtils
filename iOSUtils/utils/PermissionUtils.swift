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

class PermissionUtils {

    func configurePermission(permission: Permisson) {
        switch permission {
        case .camera:
            requestPermissionForCamera()
        case .mic:
            requestPermissionForMic()
        case .photo:
            requestPermissionForPhoto()
        case .location:
            requestPermissionForLocation()
        case .notification:
            requestPermissionForNotification()
        }
    }
    
    func requestPermissionForCamera() {
        AVCaptureDevice.requestAccess(for: .video) { (isAuthorized) in
            if !isAuthorized {
                self.denied()
            }
        }
    }
    
    func denied() {
        print("PermissionUtils -> Permission has been denied")
    }
    
    func requestPermissionForMic() {
        
    }
    
    func requestPermissionForPhoto() {
        
    }
    
    func requestPermissionForLocation() {
        
    }
    
    func requestPermissionForNotification() {
        
    }
    
    
    func jumpToSetting(controller: UIViewController, title: String, message: String, defaultAction: String?, isJumpToSetting: Bool, cancelAction: String?) {
        NotificationCenter.default.addObserver(self, selector: #selector(back), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let defaultActionTitle = defaultAction {
            alertController.addAction(UIAlertAction(title: defaultActionTitle, style: .default, handler: { (_) in
                if isJumpToSetting {
                    if let URL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                    }
                }
            }))
        }
        if let cancelActionTitle = cancelAction {
            alertController.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel, handler: { (_) in
                
            }))
        }
        controller.present(alertController, animated: true, completion: nil)
    }
    
    @objc func back() {
        print("back")
    }
}

enum Permisson {
    case camera
    case mic
    case photo
    case location
    case notification
}

